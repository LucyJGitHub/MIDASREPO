     H DEBUG
     H CVTOPT (*GRAPHIC)                                                                    MD054955
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       CSD053
/**** *  RPGBNOCVT                                                    *              CSD053 MD054955
/**** *  RPGCVTOPT1                                                   *              CSD053 MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Correspondent initial set up')
/*OVRF*: OVRDBF                                                     : *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG0001 - Initial file setup                                  *
      *                                                               *
      *  Function:  This program creates correspondent records        *
      *             with default initial values for all customers,    *
      *             alternative names and addresses, and counterparty *
      *             nostros. It will also create Correspondent        *
      *             Schedule entries to replicate the alternative     *
      *             address references on Account Details.            *
      *                                                               *
      *             IT IS INTENDED THAT THIS PROGRAM BE MODIFIED ON   *
      *             SITE TO SUIT SPECIFIC CLIENT REQUIREMENTS. SEE    *
      *             THE UDC MoPro Section 'IMPLEMENTATION NOTES' FOR  *
      *             MORE DETAILS.                                     *
      *                                                               *
      *  Called By:  - CMD/CGMIGRATE                                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054955           Date 16Dec19               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSD053             Date 01Jun06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01522             Date 13Jly95               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  S01522 - User Defined Correspondence                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  50   -    EoF migrated details                               *
      *  51   -    NrF Customer details                               *
      *                                                               *
      *****************************************************************
      *
     FCGCORRPD  O    E             DISK
     F                                     INFSR(SRFILE)
     FCGCASCPD  O    E             DISK
     F                                     INFSR(SRFILE)
     F*CGCSCHPD* O    E             DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     FSDCUSTL5  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FSDALTNL3  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FSDCNSTL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FACCNT     IF   E           K DISK
     F                                     INFSR(SRFILE)
      /EJECT
      ** Copyright statement
      *
      *COPY*CGCPYSRC,SRERRE                                                                 MD054955
      /COPY CGCPYSRC,SRERRDLE                                                               MD054955
      /EJECT
      *
     D ##DFNR          DS
     D  ##S                    1     30    INZ('Set up automatically')
      *
     D ##STMT          DS
     D  ##T                    1     10    INZ('STATEMENT ')
      *
     D ##ADRF          DS
     D  ADREF1                 1      8
     D  ADREF2                 9     10
      ** Address refernce data structure
      *
     D ##ACNT          DS
     D**********                              1   60CNUM                                      CSD027
     D  CNUM                   1      6
     D  CCY                    7      9
     D  ACOD                  10     19  0
     D  ACSQ                  20     21  0
     D  BRCA                  22     24
     D**********                             10  130ACOD                                      CGL029
     D**********                             14  150ACSQ                                      CGL029
     D**********                             16  18 BRCA                                      CGL029
      ** Full account i/d
      *
     D                 DS
     D  BCCUST                 1      6
     D**********                              1   60BCCUSN                                    CSD027
     D  BCCUSN                 1      6
      ** Redefine alternative name and address customer as numeric
      *
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      ** Copyright statement
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      ** Data Area for run-date
      *
     D CGCSCH        E DS                  EXTNAME(CGCSHJW0)                                MD054955
      *COPY*CGCPYSRC,SRERRI                                                                 MD054955
      /EJECT
      *
      ** Parameters: 1. Migrate customers (Y,N)
      **             2. Migrate Alternative names and addresses (Y,N)
      **             3. Migrate Counterparty nostros (Y,N)
      **             4. Create schedule entries for accounts (Y,N)
      **             5. Customer/correspondent prefix (optional)
      **             6. Customer/counterparty nostro prefix (optional)
     C     *ENTRY        PLIST
     C                   PARM                    P@CUST            1
     C                   PARM                    P@ALTR            1
     C                   PARM                    P@NOST            1
     C                   PARM                    P@SCHD            1
     C                   PARM                    P@CP              2
     C                   PARM                    P@NP              2
      *
      ** Set up copyright statement
     C                   MOVE      CPYR@#        CPY2@            80
      *
      ** Access run-date
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
      /EJECT
      *
      ** Part 1 - CUSTOMER DETAILS
      ** --------------------------------------------------------------
     C     P@CUST        IFEQ      'Y'
     C                   READ      SDCUSTL5                               50
      *
     C     *IN50         DOWEQ     '0'
      *
      ** Initialise record format
     C                   CLEAR                   @CORRPD
      *
      ** Use CAT to build correspondent name from prefix and customer
      ** number - if prefix is blank, CAT should suppress the blanks.
     C     P@CP          CAT       BBCUST:0      CDCORR
      *
      ** Set up remaining fields which may be defaulted
     C                   MOVEL     'D'           CDRECI
     C                   MOVEL     BBCUST        CDCUST
     C                   MOVEL     'C'           CDRTYP
     C     BBCRNM        CAT(P)    BBCRTN        CDCORN
     C                   Z-ADD     AGRDNB        CDCDTE
     C                   MOVEL     'N'           CDPLAB
     C                   Z-ADD     AGRDNB        CDATDT
     C                   MOVEL     'DEFAULT'     CDCTYP
     C                   MOVEL     'Default'     CDCSTR
     C                   MOVEL     ##DFNR        CDDESC
     C                   MOVEL     ##JOB         CDAJOB
     C                   MOVEL     ##USR         CDAUSR
     C                   TIME                    CDATIM
     C                   MOVEL     AGMRDT        CDARDT
     C                   MOVEL     'I'           CDAACT
     C                   Z-ADD     AGRDNB        CDRDNB
      *
     C/COPY WNCPYSRC,CG0001C001
      ** Write correspondent record
     C                   WRITE     @CORRPD
      *
      ** Get next customer
     C                   READ      SDCUSTL5                               50
      *
     C                   ENDDO
     C                   ENDIF
      ** --------------------------------------------------------------
      /EJECT
      *
      ** Part 2 - ALTERNATIVE NAMES & ADDRESSES
      ** --------------------------------------------------------------
     C     P@ALTR        IFEQ      'Y'
     C                   READ      SDALTNL3                               50
      *
     C     *IN50         DOWEQ     '0'
      *
      ** Initialise record format
     C                   CLEAR                   @CORRPD
      *
      ** Get customer details
     C     BCCUST        CHAIN     SDCUSTL5                           51
     C     *IN51         IFEQ      '1'
     C                   MOVEL     'SDCUSTL5'    W0FILE
     C                   MOVEL     BCCUST        W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Use CAT to build correspondent name from prefix, customer
      ** number and address code
     C     P@CP          CAT       BCCUST:0      W@CUST           10
     C     W@CUST        CAT       BCADCD:1      CDCORR
      *
      ** Set up remaining fields which may be defaulted
     C                   MOVEL     'D'           CDRECI
     C                   MOVEL     'L'           CDRTYP
     C                   MOVEL     BCCNA1        CDADD1
     C                   MOVEL     BCCNA2        CDADD2
     C                   MOVEL     BCCNA3        CDADD3
     C                   MOVEL     BCCNA4        CDADD4
     C                   MOVEL     BCCRTN        CDADD5
     C                   Z-ADD     AGRDNB        CDCDTE
     C     BBCRNM        CAT(P)    BBCRTN        CDCORN
     C                   MOVEL     'N'           CDPLAB
     C                   Z-ADD     AGRDNB        CDATDT
     C                   MOVEL     'DEFAULT'     CDCTYP
     C                   MOVEL     'Default'     CDCSTR
     C                   MOVEL     BCCTNB        CDTEL
     C                   MOVEL     ##DFNR        CDDESC
     C                   MOVEL     ##JOB         CDAJOB
     C                   MOVEL     ##USR         CDAUSR
     C                   TIME                    CDATIM
     C                   MOVEL     AGMRDT        CDARDT
     C                   MOVEL     'I'           CDAACT
     C                   Z-ADD     AGRDNB        CDRDNB
      *
     C/COPY WNCPYSRC,CG0001C002
      ** Write correspondent record
     C                   WRITE     @CORRPD
      *
      ** Create Correspondent Association (Link) record
     C                   CLEAR                   @CASCPD
     C                   MOVEL     W@CUST        CAFCOR
     C                   MOVEL     CDCORR        CATCOR
     C                   MOVEL     'D'           CARECI
     C                   MOVEL     ##DFNR        CADESC
     C                   MOVEL     ##JOB         CAAJOB
     C                   MOVEL     ##USR         CAAUSR
     C                   TIME                    CAATIM
     C                   MOVEL     AGMRDT        CAARDT
     C                   MOVEL     'I'           CAAACT
     C                   Z-ADD     AGRDNB        CARDNB
     C                   WRITE     @CASCPD
      *
      ** If requested, create additional schedule details
     C     P@SCHD        IFEQ      'Y'
     C                   EXSR      SRPRT4
     C                   ENDIF
      *
      ** Get next record
     C                   READ      SDALTNL3                               50
      *
     C                   ENDDO
     C                   ENDIF
      ** --------------------------------------------------------------
      /EJECT
      *
      ** Part 3 - COUNTERPARTY NOSTROS
      ** --------------------------------------------------------------
     C     P@NOST        IFEQ      'Y'
     C                   READ      SDCNSTL1                               50
      *
     C     *IN50         DOWEQ     '0'
      *
      ** Initialise record format
     C                   CLEAR                   @CORRPD
      *
      ** Use CAT to build correspondent name from prefix and customer
      ** number - if prefix is blank, CAT should suppress the blanks.
     C     P@NP          CAT       AWCPNC:0      CDCORR
      *
      ** Set up remaining fields which may be defaulted
     C                   MOVEL     'D'           CDRECI
     C                   MOVEL     AWCPNC        CDCPNC
     C                   MOVEL     'N'           CDRTYP
     C                   MOVEL     AWCPNM        CDADD1
     C                   MOVEL     AWCNTN        CDADD2
     C                   MOVEL     '...'         CDADD3
     C                   MOVEL     '...'         CDADD4
     C                   MOVEL     AWCPNM        CDCORN
     C                   Z-ADD     AGRDNB        CDCDTE
     C                   MOVEL     'N'           CDPLAB
     C                   Z-ADD     AGRDNB        CDATDT
     C                   MOVEL     'DEFAULT'     CDCTYP
     C                   MOVEL     'Default'     CDCSTR
     C                   MOVEL     AWBACD        CDCREF
     C                   MOVEL     ##DFNR        CDDESC
     C                   MOVEL     ##JOB         CDAJOB
     C                   MOVEL     ##USR         CDAUSR
     C                   TIME                    CDATIM
     C                   MOVEL     AGMRDT        CDARDT
     C                   MOVEL     'I'           CDAACT
     C                   Z-ADD     AGRDNB        CDRDNB
      *
     C/COPY WNCPYSRC,CG0001C003
      ** Write correspondent record
     C                   WRITE     @CORRPD
      *
      ** Get next counterparty nostro
     C                   READ      SDCNSTL1                               50
      *
     C                   ENDDO
     C                   ENDIF
      ** --------------------------------------------------------------
      /EJECT
      *
      ** End program
     C                   SETON                                        LR
      ** --------------------------------------------------------------
      /EJECT
      *
      ** Part 4 - CREATE CORRESPONDENT SCHEDULE DETAILS FOR ALTERNATIVE
      **          NAMES AND ADDRESSES.
      ** --------------------------------------------------------------
     C     SRPRT4        BEGSR
      *
      ** Access all accounts for current customer
     C     BCCUSN        CHAIN     ACCNT                              50
      *
     C                   Z-ADD     0             W@SEQN            3 0
     C     *IN50         DOWEQ     '0'
      *
      ** If live account includes a reference to the current
      ** alternative name & address, generate Correspondent Schedule
     C     RECI          IFEQ      'D'
     C     BCADCD        SCAN      ##ADRF                                 52
     C     *IN52         IFEQ      '1'
     C                   ADD       1             W@SEQN
     C                   EXSR      SRSCHD
     C                   ENDIF
     C                   ENDIF
      *
     C     BCCUSN        READE     ACCNT                                  50
     C                   ENDDO
      *
     C                   ENDSR
      ** --------------------------------------------------------------
      /EJECT
      *
      ** SRSCHD - CREATE CORRESPONDENT SCHEDULE RECORD
      ** --------------------------------------------------------------
      *
     C     SRSCHD        BEGSR
      *
      ** Initialise record format
     C**********         CLEAR                   @CSCHPD                                    MD054955
     C                   CLEAR                   CGCSCH                                     MD054955
      *
      ** Create record details:
      **  o Correspondent is alternative name and address correspondent
     C                   MOVEL     CDCORR        CPCORR
      **  o Print item type is 'STATEMENT'; subtype 'NORMAL'
     C                   MOVEL     ##STMT        CPPTYP
     C                   MOVEL     'NORMAL'      CPPSTP
      **  o Sequence no. makes record unique for
      **    Correspondent/type/subtype
     C                   Z-ADD     W@SEQN        CPSEQN
      **  o Primary corresponent is actual customer
     C                   MOVEL     W@CUST        CPPCOR
      **  o Account is full account id
     C                   MOVEL     ##ACNT        CPMACT
      **  o Default values for remaining fields
     C                   MOVEL     'D'           CPRECI
     C                   MOVEL     'N'           CPPLAB
     C                   MOVEL     'N'           CPAPDF
     C                   MOVEL     ##JOB         CPAJOB
     C                   MOVEL     ##USR         CPAUSR
     C                   TIME                    CPATIM
     C                   MOVEL     AGMRDT        CPARDT
     C                   MOVEL     'I'           CPAACT
     C                   Z-ADD     AGRDNB        CPRDNB
      *
     C**********         WRITE     @CSCHPD                                                  MD054955
     C/EXEC SQL                                                                             MD054955
     C+ insert into CGCSHBTD                                                                MD054955
     C+ (                                                                                   MD054955
     C+   CPCORR                                                                            MD054955
     C+ , CPPTYP                                                                            MD054955
     C+ , CPPSTP                                                                            MD054955
     C+ , CPSEQN                                                                            MD054955
     C+ , CPRECI                                                                            MD054955
     C+ , CPPSCH                                                                            MD054955
     C+ , CPPCOR                                                                            MD054955
     C+ , CPLGID                                                                            MD054955
     C+ , QQACCD                                                                            MD054955
     C+ , CPNPDT                                                                            MD054955
     C+ , QQMACT                                                                            MD054955
     C+ , CPPLAB                                                                            MD054955
     C+ , CPSFDY                                                                            MD054955
     C+ , CPRETP                                                                            MD054955
     C+ , CPMSHC                                                                            MD054955
     C+ , CPAPDF                                                                            MD054955
     C+ , CPOSQN                                                                            MD054955
     C+ , CPNPAG                                                                            MD054955
     C+ , CPTPAG                                                                            MD054955
     C+ , CPRDTE                                                                            MD054955
     C+ , CPRFRQ                                                                            MD054955
     C+ , CPRSDN                                                                            MD054955
     C+ , CPCCCY                                                                            MD054955
     C+ , CPCITM                                                                            MD054955
     C+ , CPBSNB                                                                            MD054955
     C+ , CPCACC                                                                            MD054955
     C+ , CPCFRQ                                                                            MD054955
     C+ , CPNTDT                                                                            MD054955
     C+ , CPACHG                                                                            MD054955
     C+ , QQCACT                                                                            MD054955
     C+ , CPPDAY                                                                            MD054955
     C+ , CPAJOB                                                                            MD054955
     C+ , CPAUSR                                                                            MD054955
     C+ , CPATIM                                                                            MD054955
     C+ , CPARDT                                                                            MD054955
     C+ , CPAACT                                                                            MD054955
     C+ , CPRDNB                                                                            MD054955
     C+ , CPACCD                                                                            MD054955
     C+ , CPMACT                                                                            MD054955
     C+ , CPCACT                                                                            MD054955
     C+ , CPMODE                                                                            MD054955
     C+ )                                                                                   MD054955
     C+ Values                                                                              MD054955
     C+ (                                                                                   MD054955
     C+   :CPCORR                                                                           MD054955
     C+ , :CPPTYP                                                                           MD054955
     C+ , :CPPSTP                                                                           MD054955
     C+ , :CPSEQN                                                                           MD054955
     C+ , :CPRECI                                                                           MD054955
     C+ , :CPPSCH                                                                           MD054955
     C+ , :CPPCOR                                                                           MD054955
     C+ , :CPLGID                                                                           MD054955
     C+ , ' '                                                                               MD054955
     C+ , :CPNPDT                                                                           MD054955
     C+ , ' '                                                                               MD054955
     C+ , :CPPLAB                                                                           MD054955
     C+ , :CPSFDY                                                                           MD054955
     C+ , :CPRETP                                                                           MD054955
     C+ , :CPMSHC                                                                           MD054955
     C+ , :CPAPDF                                                                           MD054955
     C+ , :CPOSQN                                                                           MD054955
     C+ , :CPNPAG                                                                           MD054955
     C+ , :CPTPAG                                                                           MD054955
     C+ , :CPRDTE                                                                           MD054955
     C+ , :CPRFRQ                                                                           MD054955
     C+ , :CPRSDN                                                                           MD054955
     C+ , :CPCCCY                                                                           MD054955
     C+ , :CPCITM                                                                           MD054955
     C+ , :CPBSNB                                                                           MD054955
     C+ , :CPCACC                                                                           MD054955
     C+ , :CPCFRQ                                                                           MD054955
     C+ , :CPNTDT                                                                           MD054955
     C+ , :CPACHG                                                                           MD054955
     C+ , :QQCACT                                                                           MD054955
     C+ , :CPPDAY                                                                           MD054955
     C+ , :CPAJOB                                                                           MD054955
     C+ , :CPAUSR                                                                           MD054955
     C+ , :CPATIM                                                                           MD054955
     C+ , :CPARDT                                                                           MD054955
     C+ , :CPAACT                                                                           MD054955
     C+ , :CPRDNB                                                                           MD054955
     C+ , :CPACCD                                                                           MD054955
     C+ , :CPMACT                                                                           MD054955
     C+ , :CPCACT                                                                           MD054955
     C+ , 'B'                                                                               MD054955
     C+ )                                                                                   MD054955
     C/END-EXEC                                                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ insert into CGCSHXTD                                                                MD054955
     C+ (                                                                                   MD054955
     C+   CPCORR                                                                            MD054955
     C+ , CPPTYP                                                                            MD054955
     C+ , CPPSTP                                                                            MD054955
     C+ , CPSEQN                                                                            MD054955
     C+ , CPRECI                                                                            MD054955
     C+ , CPPSCH                                                                            MD054955
     C+ , CPPCOR                                                                            MD054955
     C+ , CPLGID                                                                            MD054955
     C+ , QQACCD                                                                            MD054955
     C+ , CPNPDT                                                                            MD054955
     C+ , QQMACT                                                                            MD054955
     C+ , CPPLAB                                                                            MD054955
     C+ , CPSFDY                                                                            MD054955
     C+ , CPRETP                                                                            MD054955
     C+ , CPMSHC                                                                            MD054955
     C+ , CPAPDF                                                                            MD054955
     C+ , CPOSQN                                                                            MD054955
     C+ , CPNPAG                                                                            MD054955
     C+ , CPTPAG                                                                            MD054955
     C+ , CPRDTE                                                                            MD054955
     C+ , CPRFRQ                                                                            MD054955
     C+ , CPRSDN                                                                            MD054955
     C+ , CPCCCY                                                                            MD054955
     C+ , CPCITM                                                                            MD054955
     C+ , CPBSNB                                                                            MD054955
     C+ , CPCACC                                                                            MD054955
     C+ , CPCFRQ                                                                            MD054955
     C+ , CPNTDT                                                                            MD054955
     C+ , CPACHG                                                                            MD054955
     C+ , QQCACT                                                                            MD054955
     C+ , CPPDAY                                                                            MD054955
     C+ , CPAJOB                                                                            MD054955
     C+ , CPAUSR                                                                            MD054955
     C+ , CPATIM                                                                            MD054955
     C+ , CPARDT                                                                            MD054955
     C+ , CPAACT                                                                            MD054955
     C+ , CPRDNB                                                                            MD054955
     C+ , CPACCD                                                                            MD054955
     C+ , CPMACT                                                                            MD054955
     C+ , CPCACT                                                                            MD054955
     C+ , CPMODE                                                                            MD054955
     C+ )                                                                                   MD054955
     C+ Values                                                                              MD054955
     C+ (                                                                                   MD054955
     C+   :CPCORR                                                                           MD054955
     C+ , :CPPTYP                                                                           MD054955
     C+ , :CPPSTP                                                                           MD054955
     C+ , :CPSEQN                                                                           MD054955
     C+ , :CPRECI                                                                           MD054955
     C+ , :CPPSCH                                                                           MD054955
     C+ , :CPPCOR                                                                           MD054955
     C+ , :CPLGID                                                                           MD054955
     C+ , ' '                                                                               MD054955
     C+ , :CPNPDT                                                                           MD054955
     C+ , ' '                                                                               MD054955
     C+ , :CPPLAB                                                                           MD054955
     C+ , :CPSFDY                                                                           MD054955
     C+ , :CPRETP                                                                           MD054955
     C+ , :CPMSHC                                                                           MD054955
     C+ , :CPAPDF                                                                           MD054955
     C+ , :CPOSQN                                                                           MD054955
     C+ , :CPNPAG                                                                           MD054955
     C+ , :CPTPAG                                                                           MD054955
     C+ , :CPRDTE                                                                           MD054955
     C+ , :CPRFRQ                                                                           MD054955
     C+ , :CPRSDN                                                                           MD054955
     C+ , :CPCCCY                                                                           MD054955
     C+ , :CPCITM                                                                           MD054955
     C+ , :CPBSNB                                                                           MD054955
     C+ , :CPCACC                                                                           MD054955
     C+ , :CPCFRQ                                                                           MD054955
     C+ , :CPNTDT                                                                           MD054955
     C+ , :CPACHG                                                                           MD054955
     C+ , :QQCACT                                                                           MD054955
     C+ , :CPPDAY                                                                           MD054955
     C+ , :CPAJOB                                                                           MD054955
     C+ , :CPAUSR                                                                           MD054955
     C+ , :CPATIM                                                                           MD054955
     C+ , :CPARDT                                                                           MD054955
     C+ , :CPAACT                                                                           MD054955
     C+ , :CPRDNB                                                                           MD054955
     C+ , :CPACCD                                                                           MD054955
     C+ , :CPMACT                                                                           MD054955
     C+ , :CPCACT                                                                           MD054955
     C+ , 'B'                                                                               MD054955
     C+ )                                                                                   MD054955
     C/END-EXEC                                                                             MD054955
      *
     C                   ENDSR
      ** --------------------------------------------------------------
      /EJECT
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD054955
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD054955
**CTDATA CPY@
(c) Finastra International Limited 2001

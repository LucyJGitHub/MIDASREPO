     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME SWIFTRef BANK DIRECTORY Plus DB Updater')     *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME001463 - ME SWIFTRef BANK DIRECTORY Plus DB Updater        *
      *                                                               *
      *  Function:  This program Reads Converted File and execute     *
      *  (I/C)      SWIFTRef BANK DIRECTORY Plus (PLoader = 1),       *
      *             SWIFTRef IBAN Plus DIRECTORY (PLoader = 2),       *
      *             SWIFTRef SSI Plus (PLoader = 3) and               *
      *             SWIFTRef SEPA Plus (PLoader = 4) DB Updates       *
      *             according Full or Delta Files.                    *
      *                                                               *
      *  Called By: MEC001425 and other                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW214             Date 25Nov14               *
      *  Prev Amend No. MD023678           Date 21Nov13               *
      *                 MD023533           Date 18Nov13               *
      *                 MD022873           Date 16Oct13               *
      *                 MD022827           Date 14Oct13               *
      *                 MD022119           Date 03Sep13               *
      *                 CFT050  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  MD023678 - IBAN is incorrectly generated due to wrong        *
      *             BBAN Bank Length                                  *
      *  MD023533 - GOC0100 seq 00199 failed in COB (Recompile)       *
      *  MD022873 - CFT050 Swiftref - MEISOCPD ISO Country Codes set  *
      *             up has corrupted the data                         *
      *           - Applied for MD022900                              *
      *  MD022827 - Zeroes were added to various fields is ISOM after *
      *             switch on/off of various features.                *
      *  MD022119 - Program attempts to write a duplicate record to   *
      *             MEBICCL0                                          *
      *  CFT050 - SWIFTRef Directories upload                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *       99  Record found/not found indicator                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main routine                                                 *
      *  Loader1 - BANK DIRECTORY Plus DB Loader                      *
      *  Loader2 - IBAN Plus DIRECTORY Loader                         *
      *  Loader3 - SSI Plus DIRECTORY Loader                          *
      *  Loader4 - SEPA Plus DIRECTORY Loader                         *
      *  *INZSR  - Program Initialisation Routine                     *
      *  *PSSR   - Error handling subroutine                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ***  PLoader = '1' : BANK DIRECTORY Plus Upload
      *
     FMETIB3PD  IF   E             DISK    USROPN
      ** Bank Directory Plus - Wrk
      *
     FMETICCPD  IF   E             DISK    USROPN
      ** BIC Countries Temporary file
      *
     FMETICUPD  IF   E             DISK    USROPN
      ** Bank Directory Plus/Currency Wrk
      *
     FMETIHLPD  IF   E             DISK    USROPN
      ** Bank Directory Plus/Holiday Wrk
      *
     FMETITZPD  IF   E             DISK    USROPN
      ** Bank Directory Plus/Timezone Wrk
      *
     FMEBIB3L2  IF   E           K DISK    USROPN
     F                                     RENAME(MEBIB3D0:READREF)
      ** To get Latest Sequence in 8 Positions
      *
     FMEBIB3L0  UF A E           K DISK    USROPN
     F                                     RENAME(MEBIB3D0:BANKIDX)
     F                                     Prefix(B_)
      ** Bank Directory Plus
      *
     FMEBICCL0  UF A E           K DISK    USROPN
     F                                     RENAME(@BICCPD:CTRYIDX)
     F                                     Prefix(C_)
      ** BIC Countries file by country
      *
     FMEBICUL0  UF A E           K DISK    USROPN
     F                                     RENAME(MEBICUD0:CURRIDX)
     F                                     Prefix(U_)
      ** Bank Directory Plus - Currency
      *
     FMEBIHLL0  UF A E           K DISK    USROPN
     F                                     RENAME(MEBIHLD0:HLDIDX)
     F                                     Prefix(H_)
      ** Bank Directory Plus/Holiday
      *
     FMEBITZL0  UF A E           K DISK    USROPN
     F                                     RENAME(MEBITZD0:TIMZIDX)
     F                                     Prefix(T_)
      ** Bank Directory Plus/Timezone
      *
     FSDCSSWL2  UF A E           K DISK    USROPN
      ** Update Link to *BLANK in case of deletion in MEBIB3PD
      *
     FMEISOCL2  UF A E           K DISK    USROPN
      ** handle MEISOCPD details from MEBICCPD/MEIBNSPD amendments
      *
      ***  PLoader = '2' : IBAN Plus DIRECTORY Upload
      *
     FMETIIBPD  IF   E             DISK    USROPN
      ** IBAN Plus Directory - Wrk
      *
     FMETIISPD  IF   E             DISK    USROPN
      ** IBAN Plus Dir./IBAN Struct. -Wrk
      *
     FMEIBN3L1  IF   E           K DISK    USROPN                                           MD022873
     F                                     RENAME(MEIBN3D0:IBN3IDX2)                        MD022873
     F                                     Prefix(I2_)                                      MD022873
      ** IBAN Plus Directory                                                                MD022873
      *                                                                                     MD022873
     FMEIBN3L0  UF A E           K DISK    USROPN
     F                                     RENAME(MEIBN3D0:IBN3IDX)
     F                                     Prefix(I_)
      ** IBAN Plus Directory
      *
     FMEIBNSL0  UF A E           K DISK    USROPN
     F                                     RENAME(MEIBNSD0:IBNSIDX)
     F                                     Prefix(N_)
      ** BAN Plus Directory/Structure
      *
     FSDCTRYL2  UF A E           K DISK    USROPN
     *** Country Code by ISO Ref.
      *
      ***  PLoader = '3' : SSI  Plus DIRECTORY Upload
      *
     FMETSSIPD  IF   E             DISK    USROPN
      ** SSI Plus Directory
      *
     FMESSIPL0  UF A E           K DISK    USROPN
     F                                     RENAME(MESSIPD0:SSIPIDX)
     F                                     Prefix(S_)
      ** SEPA Plus Directory
      *
      *
      ***  PLoader = '4' : SEPA Plus DIRECTORY Upload
      *
     FMETSEPPD  IF   E             DISK    USROPN
      ** SEPA Plus Directory - Wrk
      *
     FMESEPAL0  UF A E           K DISK    USROPN
     F                                     RENAME(MESEPAD0:SEPAIDX)
     F                                     Prefix(P_)
      ** SEPA Plus
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects
      *
      * Formats for Loader '1' - BANK DIRECTORY Plus
     D TIB3DS        E DS                  EXTNAME(METIB3PD)
     D BIB3DS        E DS                  EXTNAME(MEBIB3PD)
     D                                     Prefix(B_)
      *
     D TICCDS        E DS                  EXTNAME(METICCPD)
     D BICCDS        E DS                  EXTNAME(MEBICCPD)
     D                                     Prefix(C_)
      *
     D TICUDS        E DS                  EXTNAME(METICUPD)
     D BICUDS        E DS                  EXTNAME(MEBICUPD)
     D                                     Prefix(U_)
      *
     D TIHLDS        E DS                  EXTNAME(METIHLPD)
     D BIHLDS        E DS                  EXTNAME(MEBIHLPD)
     D                                     Prefix(H_)
      *
     D TITZDS        E DS                  EXTNAME(METITZPD)
     D BITZDS        E DS                  EXTNAME(MEBITZPD)
     D                                     Prefix(T_)
      *
      * Formats for Loader '2' - IBAN Plus DIRECTORY
     D TIIBDS        E DS                  EXTNAME(METIIBPD)
     D IBN3DS        E DS                  EXTNAME(MEIBN3PD)
     D                                     Prefix(I_)
      *
     D TIISDS        E DS                  EXTNAME(METIISPD)
     D IBNSDS        E DS                  EXTNAME(MEIBNSPD)
     D                                     Prefix(N_)
      *
      * Formats for Loader '3' - SSI Plus
     D TSSIDS        E DS                  EXTNAME(METSSIPD)
     D SSIPDS        E DS                  EXTNAME(MESSIPPD)
     D                                     Prefix(S_)
      *
      * Formats for Loader '4' - SEPA Plus
     D TSEPDS        E DS                  EXTNAME(METSEPPD)
     D SEPADS        E DS                  EXTNAME(MESEPAPD)
     D                                     Prefix(P_)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WFound          S              1
      *
     D WRK5N0          S              5  0
      *
     D OLDSEQ          S              8  0
      *
     D SV_B3FIL2       S             20
      *
     D ARUN            S              1
      *
     D Ploader         S              1
      *
     D ODATE           S              8
      *
     D PRTCD           S              7
      *
     D POPTN           S              7
      *
     D CPOS1           S              1                                                     MD022827
     D CPOS2           S              1                                                     MD022827
     D DPOS1           S              1                                                     MD022827
     D DPOS2           S              1                                                     MD022827
     D DLEN1           S              1                                                     MD022827
     D DLEN2           S              1                                                     MD022827
     D BIDP1           S              1                                                     MD022827
     D BIDP2           S              1                                                     MD022827
     D BIDL1           S              1                                                     MD022827
     D BIDL2           S              1                                                     MD022827
     D BRCP1           S              1                                                     MD022827
     D BRCP2           S              1                                                     MD022827
     D BRCL1           S              1                                                     MD022827
     D BRCL2           S              1                                                     MD022827
     D INAT1           S              1                                                     MD022827
     D INAT2           S              1                                                     MD022827
     D ACNP1           S              1                                                     MD022827
     D ACNP2           S              1                                                     MD022827
     D ACNL1           S              1                                                     MD022827
     D ACNL2           S              1                                                     MD022827
     D IBNL1           S              1                                                     MD022827
     D IBNL2           S              1                                                     MD022827
      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************
      *
      **  Each loader will work the same way:
      **  Open its list of Files - Interim  and Database
      **  Read interim file and check its 'MODIFICATION FLAG'
      **  Regarding its value, insert, amend, delete in the database
      **  in Full mode, unchanged records are also inserted if they are not yet present
      *
     C                   SELECT
     C                   WHEN      PLoader = '1'
     C                   EXSR      Loader1
      *
     C                   WHEN      PLoader = '2'
     C                   EXSR      Loader2
      *
     C                   WHEN      PLoader = '3'
     C                   EXSR      Loader3
      *
     C                   WHEN      PLoader = '4'
     C                   EXSR      Loader4
      *
     C                   ENDSL
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Loader1 -  BANK DIRECTORY Plus DB Updater                    *
      *  Called by: Main                                              *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     Loader1       BEGSR
      *
      **  Open Working files (10)
      *
     C                   OPEN      METIB3PD                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'METIB3PD'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  2
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      MEBIB3L0                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEBIB3L0'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =   3
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      METICCPD                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'METICCPD'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  4
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      MEBICCL0                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEBICCL0'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  5
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      METICUPD                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'METICUPD'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  6
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      MEBICUL0                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'METICUL0'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  7
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      METIHLPD                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'METIHLPD'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  8
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      MEBIHLL0                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEBIHLL0'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  9
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      METITZPD                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'METITZPD'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  10
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      MEBITZL0                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEBITZL0'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  11
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Special Process - Customer Extension SWIFT Details File
      *
     C                   OPEN      SDCSSWL2                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCSSWL2'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  11
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Special Process - Handle MEISOCPD Records From MEBICCPD Amendment
      *
     C                   OPEN      MEISOCL2                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEISOCL2'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  11
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Do Updates according Modification Flag
      **  Insert/amend if 'A'dd
      **  Amend/Insert if 'M'odified
      **  Delete if 'D'eleted
      **  Insert if 'U'nchanged and not Found
      *
      *
      **  1) METIB3PD ==> output in MEBIB3PD
      **              ==> Handle Links Customer/BIc Ref if any (Deletion only)
      *
     C                   READ      MEBIB3D0
     C                   DOW       not(%EOF)
      *
      **  Check if record already exists and create if not and necessary
      *
     C     KBIB3         CHAIN     MEBIB3L0                           99
      *
     C                   IF        B3FLAG = 'A'
     C                             OR B3FLAG = 'M'
     C                             OR B3FLAG = 'U'
     C                   EVAL      SV_B3FIL2 = B_B3FIL2
     C                   EVAL      BIB3DS    = TIB3DS
     C                   EVAL      B_B3UDAT  = ODATE
 
     C                   IF        NOT %FOUND(MEBIB3L0)
     C                   MOVEL     OLDSEQ        B_B3FIL2
     C                   ADD       1             OLDSEQ
     C                   WRITE     BANKIDX
 
     C                   ELSEIF    B3FLAG = 'A'
     C                             OR B3FLAG = 'M'
     C                   EVAL      B_B3FIL2 = SV_B3FIL2
     C                   UPDATE    BANKIDX
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        B3FLAG = 'D'
     C                             AND %FOUND(MEBIB3L0)
     C                   DELETE    BANKIDX
      *
      ** Link will be updated to *BLANK if one is existing in SDCSSWL2 File
      *
     C     B3KEY         CHAIN     SDCSSWD0
     C                   IF        %FOUND(SDCSSWL2)
     C                   DELETE    SDCSSWD0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read Next
      *
     C                   READ      MEBIB3D0
     C                   ENDDO
      *
      ** 2) METICCPD ==> output in MEBICCPD
      **             ==> Handle Iso Country Code Definition (MEISOCPD)
      *
     C                   READ      @BICCPD
     C                   DOW       NOT(%EOF)
      *
      **  Check if record already exists and create if not and necessary
      *
     C     KBICC         CHAIN     MEBICCL0                           99
      *
     C                   IF        BCFLAG = 'A'
     C                             OR BCFLAG = 'M'
     C                             OR BCFLAG = 'U'
     C                   EVAL      BICCDS = TICCDS
 
     C                   IF        NOT %FOUND(MEBICCL0)
     C**********         WRITE     CTRYIDX                                                  MD022119
     C                   WRITE(E)  CTRYIDX                                                  MD022119
     C                   ELSEIF    BCFLAG = 'A'
     C                             OR BCFLAG = 'M'
     C                   UPDATE    CTRYIDX
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   IF        BCFLAG = 'D'
     C                             AND %FOUND(MEBICCL0)
     C                   DELETE    CTRYIDX
     C                   ENDIF
      *
      ** ISO Country Code - Update MEISOCL2 File
      ** Now Several entries per ISO Country Code is possible
      ** Record "1" : ISO Country and no IBAN ISO Country Code ==> only one Record
      ** Record "1" : ISO Country Code = IBAN ISO Country Code ==> 1 to N Records
      ** Record "N" : ISO Country Code <> IBAN ISO Country (but never blank)
      *
     C     BCCNTC        SETLL     MEISOCD0
     C     BCCNTC        READE     MEISOCD0
     C                   DOU       %EOF(MEISOCL2)
     C                   SELECT
      *
      ** Adding
      *
     C                   WHEN      BCFLAG = 'A'
     C                             or BCFLAG = 'M' and %Eof(MEISOCL2)
     C                             or BCFLAG = 'U' and %Eof(MEISOCL2)
     C                   EVAL      M3ISOC = BCCNTC
 
     C**********         IF        NOT %EOF(MEISOCL2)                                       MD022873
     C                   EVAL      M3ISOD = %SUBST(BCCNTY:1:30)
     C**********         ENDIF                                                              MD022873
 
     C                   EVAL      M3SCHT = 'N'
     C                   EVAL      M3ACJN = PSJobName
     C                   EVAL      M3ACUN = PSUser
     C                   EVAL      M3ACTM = PSRunTime
     C                   EVAL      M3ACDA = AGMRDT
     C                   EVAL      M3ACTY = 'I'
     C                   EVAL      M3EEAM = 'N'
     C                   EVAL      M3FATF = 'N'
     C                   EVAL      M3MFID = 'N'
     C                   EVAL      M3M205 = 'N'
     C
     C                   EVAL      M3SEPA = *BLANKS
     C                   EVAL      M3IBAC = *BLANKS
     C                   EVAL      M3IBAR = *BLANKS
     C                   EVAL      M3OCDT = *ZERO
     C                   EVAL      M3MCDT = *ZERO
     C                   EVAL      M3CCSP = *ZERO
     C                   EVAL      M3CCLN = *ZERO
     C                   EVAL      M3ICSP = *ZERO
     C                   EVAL      M3ICLN = *ZERO
     C                   EVAL      M3BBSP = *ZERO
     C                   EVAL      M3BBLN = *ZERO
     C                   EVAL      M3BISP = *ZERO
     C                   EVAL      M3BILN = *ZERO
     C                   EVAL      M3BRSP = *ZERO
     C                   EVAL      M3BRLN = *ZERO
     C                   EVAL      M3INLN = *ZERO
     C                   EVAL      M3ACSP = *ZERO
     C                   EVAL      M3ACLN = *ZERO
     C                   EVAL      M3TBLN = *ZERO
     C                   EVAL      M3TILN = *ZERO
      *
      ** Modification
      *
     C                   WHEN      BCFLAG = 'M'
     C                             OR BCFLAG = 'A' and not %Eof(MEISOCL2)
     C                             OR BCFLAG = 'U' and not %Eof(MEISOCL2)
                                                                                            MD022873
     C                   IF        M3ISOD = '*** NOT FOUND ***'                             MD022873
     C                   EVAL      M3ISOD = %SUBST(BCCNTY:1:30)
     C                   ENDIF                                                              MD022873
 
     C                   IF        M3SCHT <> 'Y' AND M3SCHT <> 'N'
     C                   EVAL      M3SCHT = 'N'
     C                   ENDIF
 
     C                   EVAL      M3ACJN = PSJobName
     C                   EVAL      M3ACUN = PSUser
     C                   EVAL      M3ACTM = PSRunTime
     C                   EVAL      M3ACDA = AGMRDT
     C                   EVAL      M3ACTY = 'A'
 
     C                   IF        M3SCHT <> 'Y' AND M3SCHT <> 'N'
     C                   EVAL      M3EEAM = 'N'
     C                   ENDIF
 
     C                   IF        M3SCHT <> 'Y' AND M3SCHT <> 'N'
     C                   EVAL      M3FATF = 'N'
     C                   ENDIF
 
     C                   IF        M3SCHT <> 'Y' AND M3SCHT <> 'N'
     C                   EVAL      M3MFID = 'N'
     C                   ENDIF
 
     C                   IF        M3SCHT <> 'Y' AND M3SCHT <> 'N'
     C                   EVAL      M3M205 = 'N'
     C                   ENDIF
      *
      ** Deletion
      *
     C                   WHEN      BCFLAG = 'D'
     C                             AND NOT %EOF(MEISOCL2)
     C
     C                   EVAL      M3ISOD = '****'
     C                   ENDSL
     C
     C                   IF        NOT %EOF(MEISOCL2)
     C                   UPDATE    MEISOCD0
      *
      ** Read next has at least one exists
      *
     C     BCCNTC        READE     MEISOCD0
     C                   ELSEIF    BCFLAG <> 'D'
     C                   WRITE     MEISOCD0
     C                   ENDIF
     C                   ENDDO
      *
      ** Read Next
      *
     C                   READ      @BICCPD
     C                   ENDDO
      *
      **  3) METICUPD ==> output in MEBICUPD
      *
     C                   READ      MEBICUD0
     C                   DOW       NOT(%EOF)
      *
      ** Check if record already exists and create if not and necessary
      *
     C     KBICU         CHAIN     MEBICUL0                           99
     C
     C                   IF        BUFLAG = 'A'
     C                             OR BUFLAG = 'M'
     C                             OR BUFLAG = 'U'
     C                   EVAL      BICUDS = TICUDS
 
     C                   IF        NOT %FOUND(MEBICUL0)
     C                   WRITE     CURRIDX
     C                   ELSEIF    B3FLAG = 'A'
     C                             OR B3FLAG = 'M'
     C                   UPDATE    CURRIDX
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        BUFLAG = 'D'
     C                             AND %FOUND(MEBICUL0)
     C                   DELETE    CURRIDX
     C                   ENDIF
      *
      ** Read Next
      *
     C                   READ      MEBICUD0
     C                   ENDDO
      *
      ** 4) METIHLPD ==> output in MEBIHLPD
      *
     C                   READ      MEBIHLD0
     C                   DOW       NOT(%EOF)
      *
      ** Check if record already exists and create if not and necessaryyy
      *
     C     KBIHL         CHAIN     MEBIHLL0                           99
     C                   IF        BHFLAG = 'A'
     C                             OR BHFLAG = 'M'
     C                             OR BHFLAG = 'U'
     C                   EVAL      BIHLDS = TIHLDS
 
     C                   IF        NOT %FOUND(MEBIHLL0)
     C                   WRITE     HLDIDX
     C                   ELSEIF    BHFLAG = 'A'
     C                             OR BHFLAG = 'M'
     C                   UPDATE    HLDIDX
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        BHFLAG = 'D'
     C                             AND %FOUND(MEBIHLL0)
     C                   DELETE    HLDIDX
     C                   ENDIF
      *
      ** Read Next
      *
     C                   READ      MEBIHLD0
     C                   ENDDO
      *
      ** 5) METITZPD ==> output in MEBITZPD
      *
     C                   READ      MEBITZD0
     C                   DOW       NOT(%EOF)
      *
      ** Check if record already exists and create if not and necessaryyy
      *
     C     KBITZ         CHAIN     MEBITZL0                           99
     C                   IF        BZFLAG = 'A'
     C                             OR BZFLAG = 'M'
     C                             OR BZFLAG = 'U'
     C                   EVAL      BITZDS = TITZDS
     C                   IF        NOT %FOUND(MEBITZL0)
     C                   WRITE     TIMZIDX
     C                   ELSEIF    BZFLAG = 'A'
     C                             OR BZFLAG = 'M'
     C                   UPDATE    TIMZIDX
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        BZFLAG = 'D'
     C                              AND %FOUND(MEBITZL0)
     C                   DELETE    TIMZIDX
     C                   ENDIF
      *
      ** Read Next
      *
     C                   READ      MEBITZD0
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Loader2 - IBAN Plus DIRECTORY Loader                         *
      *  Called by: Main                                              *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     Loader2       BEGSR
      *
      **  Open Working files (4)
      *
     C                   OPEN      METIIBPD                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'METIIBPD'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  12
     C                   EVAL      DBPROC =  'SR/Loader2'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      MEIBN3L0                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEIBN3L0'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  13
     C                   EVAL      DBPROC =  'SR/Loader2'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      METIISPD                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'METIISPD'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  14
     C                   EVAL      DBPROC =  'SR/Loader2'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      MEIBNSL0                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEIBNSL0'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  15
     C                   EVAL      DBPROC =  'SR/Loader2'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      MEISOCL2                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEISOCL2'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  15
     C                   EVAL      DBPROC =  'SR/Loader2'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      SDCTRYL2                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCTRYL2'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  15
     C                   EVAL      DBPROC =  'SR/Loader2'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            MD022873
     C                   OPEN      MEIBN3L1                             99                  MD022873
     C     *IN99         IFEQ      *ON                                                      MD022873
     C     *LOCK         IN        LDA                                                      MD022873
     C                   EVAL      DBFILE =  'MEIBN3L1'                                     MD022873
     C                   EVAL      DBKEY  =  'OPEN File'                                    MD022873
     C                   EVAL      DBASE  =  20                                             MD022873
     C                   EVAL      DBPROC =  'SR/Loader2'                                   MD022873
     C                   OUT       LDA                                                      MD022873
     C                   EXSR      *PSSR                                                    MD022873
     C                   ENDIF                                                              MD022873
      *
      ** Do Updates according Modification Flag
      ** Insert/amend if 'A'dd
      ** Amend/Insert if 'M'odified
      ** Delete if 'D'eleted
      ** Insert if 'U'nchanged and not Found
      *
      ** 1) METIIBPD ==> output in MEIBN3PD
      *
     C                   READ      MEIBN3D0
     C                   DOW       NOT(%EOF)
      *
      ** Check if record already exists and create if not and necessary
      *
     C     KIBN3         CHAIN     MEIBN3L0                           99
      *
     C                   IF        N3FLAG = 'A'
     C                             OR N3FLAG = 'M'
     C                             OR N3FLAG = 'U'
     C                   EVAL      IBN3DS   = TIIBDS
     C                   EVAL      I_N3UDAT = ODATE
 
     C                   IF        NOT %FOUND(MEIBN3L0)
     C                   WRITE     IBN3IDX
     C                   ELSEIF    N3FLAG = 'A'
     C                             OR N3FLAG = 'M'
     C                   UPDATE    IBN3IDX
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        N3FLAG = 'D'
     C                             AND %FOUND(MEIBN3L0)
     C                   DELETE    IBN3IDX
     C                   ENDIF
      *
      ** Read Next
      *
     C                   READ      MEIBN3D0
     C                   ENDDO
      *
      ** 2) METIISPD ==> output in MEIBNSPD
      *
     C                   READ      MEIBNSD0
     C                   DOW       NOT(%EOF)
      *
      ** Check if record already exists and create if not and necessary
      *
     C     KIBNS         CHAIN     MEIBNSL0                           99
      *
     C                   IF        NSFLAG = 'A'
     C                             OR NSFLAG = 'M'
     C                             OR NSFLAG = 'U'
     C                   EVAL      IBNSDS   = TIISDS
     C                   EVAL      N_NSUDAT = ODATE
 
     C                   IF        NOT %FOUND(MEIBNSL0)
     C                   WRITE     IBNSIDX
     C                   ELSEIF    NSFLAG = 'A'
     C                             OR NSFLAG = 'M'
     C                   UPDATE    IBNSIDX
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        NSFLAG = 'D'
     C                             AND %FOUND(MEIBN3L0)
     C                   DELETE    IBNSIDX
     C                   ENDIF
      *
      ** ISO Country Code - Update MEISOCL2 File :Combination ISOC CTRY <> IBAN CTRY = '  '
      **                                       or Combination ISOC CTRY = IBAN CTRY
      *
     C     NSCCOD        SETLL     MEISOCL2
     C                   DOU       %EOF
     C                             OR M3IBAC = '  '
     C                             OR M3IBAC = M3ISOC
     C     NSCCOD        READE     MEISOCD0
     C                   ENDDO
      *
     C                   IF        %EOF(MEISOCL2)
     C                   EVAL      WFound = 'N'
     C                   ELSE
     C                   EVAL      WFound = 'Y'
     C                   ENDIF
      *
     C                   SELECT
      *
      ** Adding
      *
     C                   WHEN      NSFLAG = 'A'
     C                             OR NSFLAG = 'U' AND WFound = 'N'
     C                   EVAL      M3ISOC = NSCCOD
     C                   EVAL      M3SCHT = 'N'
     C                   EVAL      M3ACJN = PSJobName
     C                   EVAL      M3ACUN = PSUser
     C                   EVAL      M3ACTM = PSRunTime
     C                   EVAL      M3ACDA = AGMRDT
     C                   EVAL      M3ACTY = 'I'
     C                   EVAL      M3EEAM = 'N'
     C                   EVAL      M3FATF = 'N'
     C                   EVAL      M3MFID = 'N'
     C                   EVAL      M3M205 = 'N'
 
     C     NSCCOD        CHAIN     MEIBN3L1                                                 MD022873
     C                   IF        %FOUND (MEIBN3L1)                                        MD022873
     C                   EVAL      M3ISOD = I2_N3CTY1                                       MD022873
     C                   ELSE                                                               MD022873
     C                   EVAL      M3ISOD = '*** NOT FOUND ***'                             MD022873
     C                   ENDIF                                                              MD022873
                                                                                            MD022873
     C                   IF        NSCPOS <> '00'
     C                   EVAL      M3IBAC = NSCCOD
     C                   ELSE
     C                   EVAL      M3IBAC = *Blanks
     C                   ENDIF
 
     C                   IF        NSCCOD = 'AD'
     C                             OR NSCCOD = 'AT'
     C                             OR NSCCOD = 'BE'
     C                             OR NSCCOD = 'BG'
     C                             OR NSCCOD = 'BV'
     C                             OR NSCCOD = 'CH'
     C                             OR NSCCOD = 'CY'
     C                             OR NSCCOD = 'CZ'
     C                             OR NSCCOD = 'DE'
     C                             OR NSCCOD = 'DK'
     C                             OR NSCCOD = 'EE'
     C                             OR NSCCOD = 'ES'
     C                             OR NSCCOD = 'FI'
     C                             OR NSCCOD = 'FR'
     C                             OR NSCCOD = 'GB'
     C                             OR NSCCOD = 'GF'
     C                             OR NSCCOD = 'GI'
     C                             OR NSCCOD = 'GP'
     C                             OR NSCCOD = 'GR'
     C                             OR NSCCOD = 'HU'
     C                             OR NSCCOD = 'IE'
     C                             OR NSCCOD = 'IL'
     C                             OR NSCCOD = 'IS'
     C                             OR NSCCOD = 'IT'
     C                             OR NSCCOD = 'LI'
     C                             OR NSCCOD = 'LT'
     C                             OR NSCCOD = 'LU'
     C                             OR NSCCOD = 'LV'
     C                             OR NSCCOD = 'MC'
     C                             OR NSCCOD = 'MQ'
     C                             OR NSCCOD = 'MT'
     C                             OR NSCCOD = 'NL'
     C                             OR NSCCOD = 'NO'
     C                             OR NSCCOD = 'PL'
     C                             OR NSCCOD = 'PM'
     C                             OR NSCCOD = 'PT'
     C                             OR NSCCOD = 'RE'
     C                             OR NSCCOD = 'RO'
     C                             OR NSCCOD = 'SE'
     C                             OR NSCCOD = 'SI'
     C                             OR NSCCOD = 'SJ'
     C                             OR NSCCOD = 'SK'
     C                             OR NSCCOD = 'SM'
     C                             OR NSCCOD = 'TF'
     C                             OR NSCCOD = 'VA'
     C                   EVAL      M3IBAR = 'Y'
 
     C                   ELSE
     C                   EVAL      M3IBAR = 'N'
     C                   ENDIF
 
     C                   EVAL      M3SEPA = NSSEPA
                                                                                            MD022827
     C                   EVAL      CPOS1 = %SUBST(NSCPOS:1:1)                               MD022827
     C                   EVAL      CPOS2 = %SUBST(NSCPOS:2:1)                               MD022827
     C                   IF        CPOS2 = *BLANKS AND CPOS1 <> *BLANKS                     MD022827
     C                   MOVE      CPOS1         M3CCSP                                     MD022827
     C                   ELSE                                                               MD022827
     C                   IF        NSCPOS = '\N'                                            MD022827
     C                   EVAL      M3CCSP = 0                                               MD022827
     C                   ELSE                                                               MD022827
     C                   MOVE      NSCPOS        M3CCSP
     C                   ENDIF                                                              MD022827
     C                   ENDIF                                                              MD022827
                                                                                            MD022827
     C                   MOVE      NSCLEN        M3CCLN
                                                                                            MD022827
     C                   EVAL      DPOS1 = %SUBST(NSDPOS:1:1)                               MD022827
     C                   EVAL      DPOS2 = %SUBST(NSDPOS:2:1)                               MD022827
     C                   IF        DPOS2 = *BLANKS AND DPOS1 <> *BLANKS                     MD022827
     C                   MOVE      DPOS1         M3ICSP                                     MD022827
     C                   ELSE                                                               MD022827
     C                   IF        NSDPOS = '\N'                                            MD022827
     C                   EVAL      M3ICSP = 0                                               MD022827
     C                   ELSE                                                               MD022827
     C                   MOVE      NSDPOS        M3ICSP
     C                   ENDIF                                                              MD022827
     C                   ENDIF                                                              MD022827
                                                                                            MD022827
     C                   EVAL      DLEN1 = %SUBST(NSDLEN:1:1)                               MD022827
     C                   EVAL      DLEN2 = %SUBST(NSDLEN:2:1)                               MD022827
     C                   IF        DLEN2 = *BLANKS AND DLEN1 <> *BLANKS                     MD022827
     C                   MOVE      DLEN1         M3ICLN                                     MD022827
     C                   ELSE                                                               MD022827
     C                   IF        NSDLEN = '\N'                                            MD022827
     C                   EVAL      M3ICLN = 0                                               MD022827
     C                   ELSE                                                               MD022827
     C                   MOVE      NSDLEN        M3ICLN
     C                   ENDIF                                                              MD022827
     C                   ENDIF                                                              MD022827
                                                                                            MD022827
     C                   EVAL      BIDP1 = %SUBST(NSBIDP:1:1)                               MD022827
     C                   EVAL      BIDP2 = %SUBST(NSBIDP:2:1)                               MD022827
     C                   IF        BIDP2 = *BLANKS AND BIDP1 <> *BLANKS                     MD022827
     C                   MOVE      BIDP1         M3BISP                                     MD022827
     C                   ELSE                                                               MD022827
     C                   IF        NSBIDP = '\N'                                            MD022827
     C                   EVAL      M3BISP = 0                                               MD022827
     C                   ELSE                                                               MD022827
     C                   MOVE      NSBIDP        M3BISP
     C                   ENDIF                                                              MD022827
     C                   ENDIF                                                              MD022827
                                                                                            MD022827
     C                   EVAL      BIDL1 = %SUBST(NSBIDL:1:1)                               MD022827
     C                   EVAL      BIDL2 = %SUBST(NSBIDL:2:1)                               MD022827
     C                   IF        BIDL2 = *BLANKS AND BIDL1 <> *BLANKS                     MD022827
     C                   MOVE      BIDL1         M3BILN                                     MD022827
     C                   ELSE                                                               MD022827
     C                   IF        NSBIDL = '\N'                                            MD022827
     C                   EVAL      M3BILN = 0                                               MD022827
     C                   ELSE                                                               MD022827
     C                   MOVE      NSBIDL        M3BILN
     C                   ENDIF                                                              MD022827
     C                   ENDIF                                                              MD022827
                                                                                            MD022827
     C                   EVAL      BRCP1 = %SUBST(NSBRCP:1:1)                               MD022827
     C                   EVAL      BRCP2 = %SUBST(NSBRCP:2:1)                               MD022827
     C                   IF        BRCP2 = *BLANKS AND BRCP1 <> *BLANKS                     MD022827
     C                   MOVE      BRCP1         M3BRSP                                     MD022827
     C                   ELSE                                                               MD022827
     C                   IF        NSBRCP = '\N'                                            MD022827
     C                   EVAL      M3BRSP = 0                                               MD022827
     C                   ELSE                                                               MD022827
     C                   MOVE      NSBRCP        M3BRSP
     C                   ENDIF                                                              MD022827
     C                   ENDIF                                                              MD022827
                                                                                            MD022827
     C                   EVAL      BRCL1 = %SUBST(NSBRCL:1:1)                               MD022827
     C                   EVAL      BRCL2 = %SUBST(NSBRCL:2:1)                               MD022827
     C                   IF        BRCL2 = *BLANKS AND BRCL1 <> *BLANKS                     MD022827
     C                   MOVE      BRCL1         M3BRLN                                     MD022827
     C                   ELSE                                                               MD022827
     C                   IF        NSBRCL = '\N'                                            MD022827
     C                   EVAL      M3BRLN = 0                                               MD022827
     C                   ELSE                                                               MD022827
     C                   MOVE      NSBRCL        M3BRLN
     C                   ENDIF                                                              MD022827
     C                   ENDIF                                                              MD022827
                                                                                            MD022827
     C                   EVAL      INAT1 = %SUBST(NSINAT:1:1)                               MD022827
     C                   EVAL      INAT2 = %SUBST(NSINAT:2:1)                               MD022827
     C                   IF        INAT2 = *BLANKS AND INAT1 <> *BLANKS                     MD022827
     C                   MOVE      INAT1         M3INLN                                     MD022827
     C                   ELSE                                                               MD022827
     C                   IF        NSINAT = '\N'                                            MD022827
     C                   EVAL      M3INLN = 0                                               MD022827
     C                   ELSE                                                               MD022827
     C                   MOVE      NSINAT        M3INLN
     C                   ENDIF                                                              MD022827
     C                   ENDIF                                                              MD022827
                                                                                            MD022827
     C                   EVAL      ACNP1 = %SUBST(NSACNP:1:1)                               MD022827
     C                   EVAL      ACNP2 = %SUBST(NSACNP:2:1)                               MD022827
     C                   IF        ACNP2 = *BLANKS AND ACNP1 <> *BLANKS                     MD022827
     C                   MOVE      ACNP1         M3ACSP                                     MD022827
     C                   ELSE                                                               MD022827
     C                   IF        NSACNP = '\N'                                            MD022827
     C                   EVAL      M3ACSP = 0                                               MD022827
     C                   ELSE                                                               MD022827
     C                   MOVE      NSACNP        M3ACSP
     C                   ENDIF                                                              MD022827
     C                   ENDIF                                                              MD022827
                                                                                            MD022827
     C                   EVAL      ACNL1 = %SUBST(NSACNL:1:1)                               MD022827
     C                   EVAL      ACNL2 = %SUBST(NSACNL:2:1)                               MD022827
     C                   IF        ACNL2 = *BLANKS AND ACNL1 <> *BLANKS                     MD022827
     C                   MOVE      ACNL1         M3ACLN                                     MD022827
     C                   ELSE                                                               MD022827
     C                   IF        NSACNL = '\N'                                            MD022827
     C                   EVAL      M3ACLN = 0                                               MD022827
     C                   ELSE                                                               MD022827
     C                   MOVE      NSACNL        M3ACLN
     C                   ENDIF                                                              MD022827
     C                   ENDIF                                                              MD022827
                                                                                            MD022827
     C                   EVAL      IBNL1 = %SUBST(NSIBNL:1:1)                               MD022827
     C                   EVAL      IBNL2 = %SUBST(NSIBNL:2:1)                               MD022827
     C                   IF        IBNL2 = *BLANKS AND IBNL1 <> *BLANKS                     MD022827
     C                   MOVE      IBNL1         M3TILN                                     MD022827
     C                   ELSE                                                               MD022827
     C                   IF        NSIBNL = '\N'                                            MD022827
     C                   EVAL      M3TILN = 0                                               MD022827
     C                   ELSE                                                               MD022827
     C                   MOVE      NSIBNL        M3TILN
     C                   ENDIF                                                              MD022827
     C                   ENDIF                                                              MD022827
                                                                                            MD022827
     C                   MOVE      NSODAT        M3OCDT
     C                   MOVE      NSMDAT        M3MCDT
     C                   EVAL      M3BBLN = M3TILN - 4
      *
      ** Modification
      *
     C                   WHEN      BCFLAG = 'M'
     C                             OR BCFLAG = 'U' AND WFound = 'Y'
 
     C                   IF        M3SCHT <> 'Y' AND M3SCHT <> 'N'
     C                   EVAL      M3SCHT = 'N'
     C                   ENDIF
 
     C                   EVAL      M3ACJN = PSJobName
     C                   EVAL      M3ACUN = PSUser
     C                   EVAL      M3ACTM = PSRunTime
     C                   EVAL      M3ACDA = AGMRDT
     C                   EVAL      M3ACTY = 'A'
 
     C                   IF        M3SCHT <> 'Y' AND M3SCHT <> 'N'
     C                   EVAL      M3EEAM = 'N'
     C                   ENDIF
 
     C                   IF        M3SCHT <> 'Y' AND M3SCHT <> 'N'
     C                   EVAL      M3FATF = 'N'
     C                   ENDIF
 
     C                   IF        M3SCHT <> 'Y' AND M3SCHT <> 'N'
     C                   EVAL      M3MFID = 'N'
     C                   ENDIF
 
     C                   IF        M3SCHT <> 'Y' AND M3SCHT <> 'N'
     C                   EVAL      M3M205 = 'N'
     C                   ENDIF
 
     C                   IF        NSCPOS <>  '00'
     C                   EVAL      M3IBAC = NSCCOD
     C                   ELSE
     C                   EVAL      M3IBAC = *Blanks
     C                   ENDIF
 
     C                   IF        M3IBAR  <> 'Y' AND M3IBAR <> 'N'
     C                   IF        NSCCOD = 'AD'
     C                             OR NSCCOD = 'AT'
     C                             OR NSCCOD = 'BE'
     C                             OR NSCCOD = 'BG'
     C                             OR NSCCOD = 'BV'
     C                             OR NSCCOD = 'CH'
     C                             OR NSCCOD = 'CY'
     C                             OR NSCCOD = 'CZ'
     C                             OR NSCCOD = 'DE'
     C                             OR NSCCOD = 'DK'
     C                             OR NSCCOD = 'EE'
     C                             OR NSCCOD = 'ES'
     C                             OR NSCCOD = 'FI'
     C                             OR NSCCOD = 'FR'
     C                             OR NSCCOD = 'GB'
     C                             OR NSCCOD = 'GF'
     C                             OR NSCCOD = 'GI'
     C                             OR NSCCOD = 'GP'
     C                             OR NSCCOD = 'GR'
     C                             OR NSCCOD = 'HU'
     C                             OR NSCCOD = 'IE'
     C                             OR NSCCOD = 'IL'
     C                             OR NSCCOD = 'IS'
     C                             OR NSCCOD = 'IT'
     C                             OR NSCCOD = 'LI'
     C                             OR NSCCOD = 'LT'
     C                             OR NSCCOD = 'LU'
     C                             OR NSCCOD = 'LV'
     C                             OR NSCCOD = 'MC'
     C                             OR NSCCOD = 'MQ'
     C                             OR NSCCOD = 'MT'
     C                             OR NSCCOD = 'NL'
     C                             OR NSCCOD = 'NO'
     C                             OR NSCCOD = 'PL'
     C                             OR NSCCOD = 'PM'
     C                             OR NSCCOD = 'PT'
     C                             OR NSCCOD = 'RE'
     C                             OR NSCCOD = 'RO'
     C                             OR NSCCOD = 'SE'
     C                             OR NSCCOD = 'SI'
     C                             OR NSCCOD = 'SJ'
     C                             OR NSCCOD = 'SK'
     C                             OR NSCCOD = 'SM'
     C                             OR NSCCOD = 'TF'
     C                             OR NSCCOD = 'VA'
     C                   EVAL      M3IBAR = 'Y'
 
     C                   ELSE
     C                   EVAL      M3IBAR = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      M3SEPA = NSSEPA
     C                   MOVE      NSCPOS        M3CCSP
     C                   MOVE      NSCLEN        M3CCLN
     C                   MOVE      NSDPOS        M3ICSP
     C                   MOVE      NSDLEN        M3ICLN
     C                   MOVE      NSBIDP        M3BISP
     C                   MOVE      NSBIDL        M3BILN
     C                   Move      NSBRCP        M3BRSP
     C                   MOVE      NSBRCL        M3BRLN
     C                   MOVE      NSINAT        M3INLN
     C                   MOVE      NSACNP        M3ACSP
     C                   MOVE      NSACNL        M3ACLN
     C                   MOVE      NSIBNL        M3TILN
     C                   MOVE      NSODAT        M3OCDT
     C                   MOVE      NSMDAT        M3MCDT
     C                   EVAL      M3BBLN = M3TILN - 4
      *
      ** Deletion
      *
     C                   WHEN      BCFLAG = 'D'
     C                             AND NOT %EOF(MEISOCL2)
      *
     C                   EVAL      M3ISOD = '****'
     C                   ENDSL
      *
     C                   IF        NOT %EOF(MEISOCL2)
     C                   UPDATE    MEISOCD0
     C                   ELSEIF    BCFLAG <> 'D'
     C                   WRITE     MEISOCD0
     C                   ENDIF
      *
      ** Only amend existing Country using the ISO Country Code
      *
     C     M3ISOC        SETLL     SDCTRYL2
     C     M3ISOC        READE     SDCTRYL2
     C                   DOW       NOT %EOF(SDCTRYL2)
     C                   IF        BCFLAG <> 'D'
     C**********         EVAL      A4BBRL= M3BILN                                           MD023678
     C                   EVAL      A4BBRL= M3TBLN                                           MD023678
     C                   EVAL      A4BBAN = M3BBLN
     C                   ELSE
     C                   EVAL      A4BBRL= 0
     C                   EVAL      A4BBAN = 0
     C                   ENDIF
     C                   UPDATE    SDCTRYD0
     C     M3ISOC        READE     SDCTRYL2
     C                   ENDDO
      *
      ** Read Next
      *
     C                   READ      MEIBNSD0
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *   Loader3 - SSI Plus Loader                                   *
      *****************************************************************
      *
     C     Loader3       BEGSR
      *
      ** Open Working files (2)
      *
     C                   OPEN      METSSIPD                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'METSSIPD'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  16
     C                   EVAL      DBPROC =  'SR/Loader3'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      MESSIPL0                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MESSIPL0'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  17
     C                   EVAL      DBPROC =  'SR/Loader3'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Do Updates according Modification Flag
      ** Insert/amend if 'A'dd
      ** Amend/Insert if 'M'odified
      ** Delete if 'D'eleted
      ** Insert if 'U'nchanged and not Found
      *
      ** 1) METSSIPD ==> output in MESSIPPD
      *
     C                   READ      MESSIPD0
     C                   DOW       NOT(%EOF)
      *
      ** Check if record already exists and create if not and necessary
      *
     C     KSSIP         CHAIN     MESSIPL0                           99
      *
     C                   IF        SIFLAG = 'A'
     C                             OR SIFLAG = 'M'
     C                             OR SIFLAG = 'U'
     C                   EVAL      SSIPDS   = TSSIDS
     C                   EVAL      S_SIUDAT = ODATE
     C                   IF        NOT %FOUND(MESSIPL0)
     C                   WRITE     SSIPIDX
     C                   ELSEIF    SIFLAG = 'A'
     C                             OR SIFLAG = 'M'
     C                   UPDATE    SSIPIDX
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        SIFLAG = 'D'
     C                             AND %FOUND(MESSIPL0)
     C                   DELETE    SSIPIDX
     C                   ENDIF
      *
      ** Read Next
      *
     C                   READ      MESSIPD0
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *   Loader4 - SEPA Plus Loader                                  *
      *****************************************************************
      *
     C     Loader4       BEGSR
      *
      ** Open Working files (2)
      *
     C                   OPEN      METSEPPD                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'METSEPPD'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  18
     C                   EVAL      DBPROC =  'SR/Loader4'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      MESEPAL0                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MESEPAL0'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  19
     C                   EVAL      DBPROC =  'SR/Loader4'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Do Updates according Modification Flag
      ** Insert/amend if 'A'dd
      ** Amend/Insert if 'M'odified
      ** Delete if 'D'eleted
      ** Insert if 'U'nchanged and not Found
      *
      ** 1) METSEPPD ==> output in MESEPAPD
      *
     C                   READ      MESEPAD0
     C                   DOW       NOT %EOF
      *
      ** Check if record already exists and create if not and necessary
      *
     C     KSEPA         CHAIN     MESEPAL0                           99
      *
     C                   IF        SPFLAG = 'A'
     C                             OR SPFLAG = 'M'
     C                             OR SPFLAG = 'U'
     C                   EVAL      SEPADS   = TSEPDS
     C                   EVAL      P_SPUDAT = ODATE
     C                   IF        NOT %FOUND(MESEPAL0)
     C                   WRITE     SEPAIDX
     C                   ELSEIF    SPFLAG = 'A'
     C                             OR SPFLAG = 'M'
     C                   UPDATE    SEPAIDX
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        SPFLAG = 'D'
     C                             AND %Found(MESEPAL0)
     C                   DELETE    SEPAIDX
     C                   ENDIF
      *
      ** Read Next
      *
     C                   READ      MESEPAD0
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLoader
     C                   PARM                    ODATE
      *
      ** Define RUNDAT and LDA
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
     C                   EVAL      WRK5N0 = AGRDNB
      *
      ** Define LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  'ME001463'
     C                   EVAL      DBFILE =  *BLANKS
     C                   EVAL      DBKEY  =  *BLANKS
     C                   EVAL      DBASE  =  0
     C                   OUT       LDA
      *
      ** Retrieve bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Define KList
      *
     C     KBIB3         KLIST
     C                   KFLD                    B3KEY
      *
     C     KBICC         KLIST
     C                   KFLD                    BCCNTY
      *
     C     KBICU         KLIST
     C                   KFLD                    BUCYCD
     C                   KFLD                    BUCTRY
      *
     C     KBIHL         KLIST
     C                   KFLD                    BHCNTC
     C                   KFLD                    BHHDAT
     C                   KFLD                    BHHTYP
      *
     C     KBITZ         KLIST
     C                   KFLD                    BZCNTC
     C                   KFLD                    BZREGN
     C                   KFLD                    BZSDAT
      *
     C     KIBN3         KLIST
     C                   KFLD                    N3KEY
      *
     C     KIBNS         KLIST
     C                   KFLD                    NSCCOD
      *
     C     KSSIP         KLIST
     C                   KFLD                    SIKEY
      *
     C     KSEPA         KLIST
     C                   KFLD                    SPKEY
      *
     C                   OPEN      MEBIB3L2                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEBIB3L2'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  2
     C                   EVAL      DBPROC =  'SR/Loader1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Keep in old seq the next free sequence
      *
     C     *HIVAL        SETLL     MEBIB3L2
     C                   READP     MEBIB3L2
      *
     C                   IF        %EOF
     C                   Z-ADD     1             OLDSEQ
     C                   ELSE
     C                   MOVEL     B3FIL2        OLDSEQ
     C                   ADD       1             OLDSEQ
     C                   ENDIF
      *
     C                   CLOSE     MEBIB3L2                             99
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  File Exception/Error Handling Subroutine          *
      *  Called by: Various                                           *
      *  Calls    : DBERRCTL - DB Error Control                       *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        ARUN = *BLANKS
     C                   EVAL      ARUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Aggregate Facility Processing')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000058 - Aggregated Facility Processing                    *
      *                                                               *
      *  Function:  This program will drop reversed, closed and       *
      *  (COB)      expired aggregated facilities from file, and      *
      *             set aggregated facilities that have reached       *
      *             expiry date to 'Expired'.                         *
      *                                                               *
      *  Called By: LEC000058 - Aggregated Facility Processing        *
      *                         Control                               *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE147             Date 30Sep11               *
      *                 CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE041  *CREATE    Date 11Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE147 - Aggregate Facility                                  *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************
     FLE000058AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
      ** Aggregated Facility Processing - Audit
 
     FLEFCGRL1  IF   E           K DISK    INFSR(*PSSR)
      ** Facility Group by Aggregate Facility Reference Number
 
     FLEAGFCL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYFMF)
     F                                     IGNORE(FCLTYFNF)
      ** Aggregate Facility File Header and Trailer
 
     FLEAGFYL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AA)
      ** Aggregate Facilities detail A file
 
     FLEAGFYL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AB)
      ** Aggregate Facilities detail B file
 
     FLEAGFYL4  UF   E           K DISK    INFSR(*PSSR)
      ** Aggregate Facilities extension file
 
     FLEAGNMPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AA)
     F                                     RENAME(FCLTYFMF:NFCLTYFMF)
      ** New Aggregate Facilities detail A file
 
     FLEAGNNPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AB)
     F                                     RENAME(FCLTYFNF:NFCLTYFNF)
      ** New Aggregate Facilities detail B file
 
     FLEAGNHPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYHHF:NFCLTYHHF)
      ** New Aggregate Facilities Trailer file
 
     FLEAGNZPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYZZF:NFCLTYZZF)
      ** New Aggregate Facilities Trailer file
 
     FLEAGAML0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AM)
      ** Aggregate Facility Amendment File
 
      *****************************************************************
      /EJECT
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
 
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundate data area
 
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
     D SPOOLU          DS
      ***  File Information Data Structure for LE000051AU
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D                 DS
     D WkAGFclt                1     14
     D WkFclty                 4     14
     D AABRCA                  1      3
     D*AACNUM***               4      9  0                                                    CSD027
     D AACNUM                  4      9                                                       CSD027
     D AAFACT                 10     12  0
     D AAFCNO                 13     14  0
     D WkCNumA                 4      9
     D WkFacTA                10     12
     D WkFcNoA                13     14
 
      ***  Dummy Data Structures used by Access Programs.
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External data structures for Bank Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External data structures for General Ledger ICD
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  External data structures for Customer Lending ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  Short data structures for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PSeq            S              5
     D PEnty           S              3
     D PRtCd           S              7
     D POptn           S              7
     D PZSErr          S              1
     D PZSNum          S              6  0
     D PSFile          S             10
     D WRun            S              1
     D ACT@            S             80
     D WkRetDat        S              5  0
     D PZDate5         S              5  0
     D PZDate6         S              6  0
     D PZDate7         S              7
     D FFTOTI          S             15  0
     D FFTOTD          S              3  0
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZAMT           S             15  3
     D FACRTN          S              1  0
     D FACREM          S              2  0
     D WkStr4          S              4
     D WkRunYear       S              2  0
     D WkRunMnth       S              2  0
     D WkRtnYear       S              2  0
     D WkRtnMnth       S              2  0
     D WkErrFlag       S              1
     D WkFacDrop       S              1
     D WkDayRun        S              8
     D WkEvCD          S              5  0
     D NFCLTY          S              5  0
     D NFCUPD          S              5  0
     D @NLRA           S              5  0
     D VLAFB           S             15  0
     D VLALB           S              3  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 3
      *****************************************************************
      /EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Perform Initialisation.
     C                   EXSR      SRInit
 
      ** Perform Detail Processing.
     C                   EXSR      SRProcess
 
      ** Output Audit Report and End Program.
     C                   EXSR      SRAudit
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Subroutine to do Program Initialisation.            *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Set up copyright parameter
     C                   MOVEA     CPY@          ACT@
 
      ** Initialise LDA field.
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBMOD = 'LE000058'
     C                   EVAL      DBPGM = 'LE000058'
     C                   OUT       LDA
 
      ** Access RUNDAT for multibranching indicator
     C                   IN        RUNDAT
 
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check System Date Format, DDMMYY (*IN98 off)
      **                           MMDDYY (*IN98 on).
     C                   IF        BJDFIN = 'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
 
      ** Determine Day's Run (whether Yearend or Monthend or neither)
     C                   EVAL      WkDayRun = *BLANKS
     C                   EXSR      SRDetDayRun
 
      ** Call Access Program for General Ledger Details
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSFDY
 
      ** Handle Database Error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set the Event Control Date
     C                   EVAL      WkEvCD = BJDNWD-1
     C                   IF        BKAPDT < WkEvCD
     C                   EVAL      WkEvCD = BKAPDT
     C                   ENDIF
 
      ** Call Access Program for General Ledger Details
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
 
      ** Handle Database Error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SDCLNDPD'
     C                   EVAL      DBKEY = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key list for Facility
     C     KLFclt1       KLIST
     C                   KFLD                    AABRCA
     C                   KFLD                    AACNUM
     C                   KFLD                    AAFACT
     C                   KFLD                    AAFCNO
 
      ** Key list for Facility
     C     KLFclt2       KLIST
     C                   KFLD                    AACNUM
     C                   KFLD                    AAFACT
     C                   KFLD                    AAFCNO
 
      ** Key list for Facility
     C     KLFclt3       KLIST
     C                   KFLD                    AABRCA
     C                   KFLD                    WkCNumA
     C                   KFLD                    WkFacTA
     C                   KFLD                    WkFcNoA
 
      ** Ensure Audit Spool File recorded by RCF
     C                   MOVEL     SFILEU        PSFile
     C                   Z-ADD     SFNUMU        PZSNum
 
     C                   EXSR      SRRCFProc
 
      ** Number of records read
     C                   EVAL      NFCLTY = 0
 
      ** Value of records read
     C                   EVAL      FFTOTI = 0
     C                   EVAL      FFTOTD = 0
 
      ** Number of records written on file (header and trailer included)
     C                   EVAL      NFCUPD = 2
 
      ** Number of live/expired records written
     C                   EVAL      @NLRA = 0
 
      ** Value of records written on file
     C                   EVAL      VLAFB = 0
     C                   EVAL      VLALB = 0
 
      ** Determine retention date
     C                   EXSR      SRDetRetDat
 
      ** Create header record
     C                   EXSR      SRCrtHeader
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCrtHeader - Subroutine to Create Header Record for the     *
      *                New Aggregate facilities file                  *
      *                                                               *
      *****************************************************************
     C     SRCrtHeader   BEGSR
 
     C                   EVAL      RECI = 'H'
     C**********         EVAL      CNUM = *ZEROS                                              CSD027
     C                   EVAL      CNUM = *BLANKS                                             CSD027
     C                   EVAL      FACT = *ZEROS
     C                   EVAL      FCNO = *ZEROS
     C                   EVAL      RCDT = *BLANKS
     C                   EVAL      ZZ243 = *BLANKS
 
     C                   WRITE     NFCLTYHHF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetDayRun - Subroutine to Determine the Day's Run          *
      *                                                               *
      *****************************************************************
     C     SRDetDayRun   BEGSR
 
      ** If the next working day is greater than end-of-year day number
      ** then, today is a yearend run
     C                   IF        BJDNWD > BJEYD
     C                   EVAL      WkDayRun = 'YEAREND '
 
      ** Else, check if today is a monthend run
     C                   ELSE
 
     C                   EVAL      PZDate5 = BJDNWD
     C                   CALL      'ZDATE2'
     C                   PARM                    PZDate5
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PZDate6
     C                   PARM      *BLANKS       PZDate7
 
      ** If month of the next working day is not equal to today's month,
      ** then, today is a monthend run
     C                   IF        %SUBST(PZDate7:3:3) <> %SUBST(BJMRDT:3:3)
     C                   EVAL      WkDayRun = 'MONTHEND'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcFclt - Subroutine to Process Facility                  *
      *                                                               *
      *****************************************************************
     C     SRProcFclt    BEGSR
 
     C                   EVAL      WkFacDrop = 'N'
 
     C                   IF        AARECI = 'E' OR AARECI = 'C'
 
      ** Determine if Facility should be dropped
     C                   EXSR      SRDetFacDrop
 
      ** If the aggregate facility is not dropped, write this to the new
      ** file
     C                   IF        WkFacDrop = 'N'
     C                   WRITE     NFCLTYFMF
     C                   WRITE     NFCLTYFNF
 
      ** Increment number of records written
     C                   ADD       2             NFCUPD
 
      ** If facility is expired(not closed), add facility amount to
      ** the value of records written on file
     C                   IF        AARECI = 'E'
     C                   MOVE      AAFAMT        ZZAMT
     C                   IF        AAFAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
     C                   Z-ADD     VLAFB         ZZTOTI
     C                   Z-ADD     VLALB         ZZTOTD
     C                   EXSR      SRGLZADD
     C                   Z-ADD     ZZTOTI        VLAFB
     C                   Z-ADD     ZZTOTD        VLALB
 
      ** Increment number of live/expired records written
     C                   ADD       2             @NLRA
     C                   ENDIF
 
      ** Else, the aggregate facility is dropped, delete the extension
      ** record as well
     C                   ELSE
 
     C     KLFclt3       CHAIN     LEAGFYL4
     C                   IF        %FOUND(LEAGFYL4)
     C                   DELETE    LEFCLTD0
     C                   ENDIF
 
     C                   ENDIF
 
      ** Endif for If AARECI = 'E' or 'C'
     C                   ENDIF
 
     C                   IF        AARECI = 'D'
 
     C                   IF        AADTEX <= WkEvCD
     C                   EVAL      AARECI = 'E'
     C                   EVAL      ABRECI = 'E'
     C                   ENDIF
 
      ** Write aggregate record to both detail A and B file
     C                   WRITE     NFCLTYFMF
     C                   WRITE     NFCLTYFNF
 
      ** Increment number of records written
     C                   ADD       2             NFCUPD
 
      ** Perform hash totalling
     C                   MOVE      AAFAMT        ZZAMT
     C                   IF        AAFAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
     C                   Z-ADD     VLAFB         ZZTOTI
     C                   Z-ADD     VLALB         ZZTOTD
     C                   EXSR      SRGLZADD
     C                   Z-ADD     ZZTOTI        VLAFB
     C                   Z-ADD     ZZTOTD        VLALB
 
      ** Increment number of live/expired records written
     C                   ADD       2             @NLRA
 
      ** Endif for If AARECI = 'D'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetFacDrop - Subroutine to Determine if Aggregate Facility *
      *                 Should be Dropped                             *
      *                                                               *
      *****************************************************************
     C     SRDetFacDrop  BEGSR
 
      ** Consider only dropping of facilities when monthend or yearend run
     C                   IF        BPEFRP >= 0 AND BPEFRP < 99 AND
     C                             WkDayRun = 'MONTHEND' AND ABCAMD = 0 OR
     C                             BPEFRP >= 0 AND BPEFRP < 99 AND
     C                             WkDayRun = 'YEAREND ' AND ABCAMD = 0
 
      ** Check if Aggregate Facility is reactivated
     C     KLFclt1       SETLL     LEAGAML0
     C     KLFclt1       READE     LEAGAML0                               33
     C                   DOW       *IN33 = *OFF AND
     C                             AMFATP <> 'FR'
     C     KLFclt1       READE     LEAGAML0                               33
     C                   ENDDO
 
      ** If Aggregate Facility is not reactivated, check if it is attached
      ** to a tranche (i.e. it exists in LEFCGRL1)
     C                   IF        *IN33 = *ON
     C     WkAGFclt      CHAIN     LEFCGRL1
 
      ** If Aggregate Facility is not attached to a tranche, do the final check,
      ** i.e. against the retention date
     C                   IF        NOT(%FOUND(LEFCGRL1))
     C                   IF        WkRetDat <> 0 AND AADTEX < WkRetDat OR
     C                             WkRetDat = 0 AND AADTEX < AGRDNB
     C                   EVAL      WkFacDrop = 'Y'
     C                   ENDIF
 
     C                   IF        AARECI = 'C' AND WkDayRun = 'MONTHEND'
     C                   EVAL      WkFacDrop = 'Y'
     C                   ENDIF
     C                   ELSE                                                                 CLE147
     C                   IF        FCDLTD = 'Y'                                               CLE147
     C                   EVAL      WkFacDrop = 'Y'                                            CLE147
     C                   ENDIF                                                                CLE147
     C                   ENDIF
 
     C                   ENDIF
 
      ** Monthend or yearend run
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetRetDat - Subroutine to Determine the Retention Date     *
      *                                                               *
      *****************************************************************
     C     SRDetRetDat   BEGSR
 
      ** If expired facility retention period is 0, then bypass retention date
      ** checking
     C                   IF        BPEFRP > 0
 
      ** Check the retention period for the number of years and months
      ** and move the year and month values into appropriate fields
     C                   IF        BPEFRP > 12
     C     BPEFRP        DIV       12            FACRTN
     C                   MVR                     FACREM
     C                   ELSE
     C                   Z-ADD     0             FACRTN
     C                   Z-ADD     BPEFRP        FACREM
     C                   ENDIF
 
      ** Convert Rundate into DDMMYY/MMDDYY Format
     C                   Z-ADD     AGRDNB        PZDate5
     C                   CALL      'ZDATE2'
     C                   PARM                    PZDate5
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PZDate6
     C                   PARM      *BLANKS       PZDate7
 
      ** Create two separate fields for the month and the year
      ** from the resulting date
 
      ** European date format (DDMMYY)
     C                   IF        *IN98 = *OFF
     C                   MOVE      PZDate6       WkStr4
     C                   MOVE      PZDate6       WkRunYear
     C                   MOVEL     WkStr4        WkRunMnth
 
      ** US date format (MMDDYY)
     C                   ELSE
     C                   MOVE      PZDate6       WkRunYear
     C                   MOVEL     PZDate6       WkRunMnth
     C                   ENDIF
 
      ** Add one to the month to check whether to be dropped at coming monthend
     C                   ADD       1             WkRunMnth
 
      ** Check that new month number valid and adjust accordingly
     C                   IF        WkRunMnth > 12
     C                   ADD       1             WkRunYear
     C     WkRunMnth     SUB       12            WkRunMnth
     C                   ENDIF
 
      ** And use the retention period to calculate the date for
      ** dropping expired facilities
     C     WkRunYear     SUB       FACRTN        WkRtnYear
     C     WkRunMnth     SUB       FACREM        WkRtnMnth
 
      ** Check whether the resulting month is negative and if so, adjust
      ** accordingly
     C                   IF        WkRtnMnth <= 0
     C                   SUB       1             WkRtnYear
     C                   ADD       12            WkRtnMnth
     C                   ENDIF
 
      ** To cater for dates past the year 2000, check for negative
      ** year.  If so, add 100 to negative year.
     C                   IF        WkRtnYear < 0
     C                   ADD       100           WkRtnYear
     C                   ENDIF
 
      ** Construct check date with day number 01
     C                   EVAL      WkStr4 = *BLANKS
 
     C** European date format (DDMMYY)
     C                   IF        *IN98 = *OFF
     C                   MOVEL     '01'          WkStr4
     C                   MOVE      WkRtnMnth     WkStr4
 
      ** US date format (MMDDYY)
     C                   ELSE
     C                   MOVE      '01'          WkStr4
     C                   MOVEL     WkRtnMnth     WkStr4
     C                   ENDIF
 
     C                   MOVE      WkRtnYear     PZDate6
     C                   MOVEL     WkStr4        PZDate6
 
      ** Convert resulting date into a Midas Day Number
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PZDate6
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate5
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'ZDATE1'
     C                   MOVE      *BLANKS       PZDate6
     C                   MOVEL     PZDate6       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WkRetDat = PZDate5
 
      ** If expired facility retention period is 0, make Check Date 0
     C                   ELSE
     C                   EVAL      WkRetDat = 0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine to do the Detail Processing           *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
 
      ** Read first record from File.
     C     *LOVAL        SETLL     LEAGFYL1
     C                   READ      LEAGFYL1                               31
 
      ** Do While not End of File
     C                   DOW       *IN31 = *OFF
 
      ** Access corresponding detail B
     C     KLFclt2       CHAIN     LEAGFYL2
     C                   IF        NOT(%FOUND(LEAGFYL2))
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'LEAGFYL2'
     C                   EVAL      DBKEY = WkFclty
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        AARECI = 'D' OR AARECI = 'R' OR
     C                             AARECI = 'E' OR AARECI = 'C'
     C                   ADD       2             NFCLTY
 
      ** For live and expired records, add facility amount (through hash totalling)
      ** to the value of records read (FFTOTI/FFTOTD)
     C                   IF        AARECI = 'D' OR AARECI = 'E'
     C                   MOVE      AAFAMT        ZZAMT
     C                   IF        AAFAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
     C                   Z-ADD     FFTOTI        ZZTOTI
     C                   Z-ADD     FFTOTD        ZZTOTD
     C                   EXSR      SRGLZADD
     C                   Z-ADD     ZZTOTI        FFTOTI
     C                   Z-ADD     ZZTOTD        FFTOTD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Process Facility
     C                   EXSR      SRProcFclt
 
     C                   READ      LEAGFYL1                               31
 
     C                   ENDDO
 
      ** Write a record to New Aggregate Facilities Trailer file and
      ** generate Audit report
     C                   EXSR      SRCrtTrailer
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGLZSUM - Subroutine to Carry out the Addition for SRGLZADD *
      *                                                               *
      *****************************************************************
     C     SRGLZSUM      BEGSR
 
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
 
      ** Determine sign of ZZAMTI & D,  92 if negative
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND
 
      ** Determine sign of ZZTOTI & D, 91 if negative
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
 
      ** If ZZTOTAL is zero, return ZZAMOUNT
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND
 
      ** If signs differ, bypass overflow checks
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
 
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93
 
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
 
      ** If the modulus of ZZWK3 is lt mod. ZZTOTI then O/F has occured
     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
 
      ** If O/F zeroise ZZAMT, Ind '99' set and ZZTOT fields left intact
     C   99              Z-ADD     0             ZZAMT            15 3
     C                   GOTO      ZZSEND
 
      ** The 'signs' are different
     C     ZZOFPS        TAG
 
      ** If ZZAMT was negative, make it pos. to comp with ZZTOT
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
 
      ** If ZZTOT was negative, make it pos. to comp with ZZAMT.
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
 
      ** Both ZZAMT and ZZTOT are now positive
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
 
      ** If ZZTOT eq. ZZAMT return ZERO.
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
 
      ** If ZZTOT gt. ZZAMT.
     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
 
      ** If ZZAMT gt. ZZTOT.
     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
 
      ** Reverse sign of ZZTOT if larger I/P fields were negative
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
 
      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG
 
      **   If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGLZADD - Add an Amount to the Total                        *
      *                                                               *
      *****************************************************************
     C     SRGLZADD      BEGSR
 
     C                   Z-ADD     ZZAMT         ZZAMT                    91
     C                   IF        ZZAMT = 0
     C                   GOTO      ZZAEND
     C                   ENDIF
 
     C                   IF        ZZAMT <> 0
 
      ** Split ZZAMT into integer and decimal fields
 
     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD
 
      **  Both ZZAMTI and ZZAMTD contain a 'SIGN' zone now
 
     C                   EXSR      SRGLZSUM
 
     C                   ENDIF
 
     C     ZZAEND        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCrtTrailer - Subroutine that Creates New Aggregate         *
      *                 Facilities Trailer File                       *
      *                                                               *
      *****************************************************************
     C     SRCrtTrailer  BEGSR
 
      ** Read trailer record of the old aggregate facility
     C                   READ      FCLTYZZF                               31
 
     C                   IF        *IN31 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'LEAGFZPD'
     C                   EVAL      DBKEY = '*READ'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ADD       2             NFCLTY
 
      ** Check imbalance
     C                   IF        NFCLTY <> NORE OR
     C                             FFTOTI <> VLAF OR
     C                             FFTOTD <> VLAL
     C                   EVAL      *IN30 = *ON
     C                   EVAL      *INU7 = *ON
     C                   ENDIF
 
      ** Set report fields to be written to audit report - LE000058AU
     C                   EVAL      RCOUN1 = NORE
     C                   MOVEL     VLAF          RHASH1
     C                   MOVE      VLAL          RHASH1
 
     C                   EVAL      RCOUN2 = NFCLTY
     C                   MOVEL     FFTOTI        RHASH2
     C                   MOVE      FFTOTD        RHASH2
 
     C                   EVAL      RCOUN3 = NFCUPD
     C                   MOVEL     VLAFB         RHASH3
     C                   MOVE      VLALB         RHASH3
 
      ** Set file fields to be written to trailer file - LEAGNZPD
     C                   EVAL      NORE = NFCUPD
     C                   EVAL      LCD = *ZEROS
     C                   EVAL      CHTP = *BLANKS
     C                   EVAL      TNLU = *ZEROS
     C                   EVAL      NLRB = @NLRA
     C                   EVAL      VLBF = VLAFB
     C                   EVAL      VLBL = VLALB
     C                   EVAL      NLRA = @NLRA
     C                   EVAL      VLAF = VLAFB
     C                   EVAL      VLAL = VLALB
 
     C                   WRITE     NFCLTYZZF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Generate Audit Report & End Program  *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
      ** If there is a DB Error, Output the DB Error Information.
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF
 
      ** End Program and Return.
     C                   MOVE      *ON           *INLR
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called.
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here.
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFProc - Subroutine to register Printer File via RCF      *
      *                                                               *
      *****************************************************************
     C     SRRCFProc     BEGSR
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANKS       PZSErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
     C                   IF        PZSErr = 'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004

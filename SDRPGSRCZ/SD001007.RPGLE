     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Daylight Savings Time Change Date')
      *****************************************************************
      *                                                               *
      *  Midas - MIDAS Common Routines                                *
      *                                                               *
      *  SD001007 - Midas SD Daylight Savings Time Change Date        *
      *                                                               *
      *  Function:  This is a new program that will run in input      *
      *             DSt rules specified in DST file is satisfied      *
      *             and will update start and end date.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG21195           Date 25Sep08               *
      *  Prev Amend No. BUG21251           Date 03Oct08               *
      *                 BUG20226           Date 15Aug08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG21195 - COB - SCC0411-ZFINDDATE failed when called by     *
      *             SD001007                                          *
      *  BUG21251 - Branch details not changed at DST change date     *
      *  BUG20226 - Database error occurred during "Copy" mode        *
      *             (Recompile)                                       *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *Pssr    - Error Processing                                  *
      *  *INZSR   - Program Initialisation Routine                    *
      *  SrFindDate - Subroutine to get the next start or end date    *
      *  SrUpdates - Subroutine to access time zone details which     *
      *              uses the dst code                                *
      *  SrUpdHist - Subroutine to write out to history file          *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDDSTCL1  IF   E           K DISK    INFSR(*Pssr)
     F                                     PREFIX(H1)
 
      ** Time Zone File
     FSDTIZOL2  IF   E           K DISK    INFSR(*Pssr)
 
      ** Time Zone File
     FSDTIZOL1  IF   E           K DISK    INFSR(*Pssr)
     F                                     PREFIX(F1)
     F                                     RENAME(SDTIZOD0:SDTIZOR1)
 
      ** SD Market Identification Code File
     FSDMICCL1  IF   E           K DISK    INFSR(*Pssr)
 
      ** Time Zone History File
     FSDTIZHL1  IF   E           K DISK    INFSR(*Pssr)
     F                                     PREFIX(G1)
 
      ** Time Zone Level Code File 1
     FSDTZLVL2  IF   E           K DISK    INFSR(*Pssr)
     F                                     PREFIX(I1)
     F                                     RENAME(SDTZLVD0:SDTZLVR1)
 
      ** Time Zone Level Code File 2
     FSDTZLVL3  IF   E           K DISK    INFSR(*Pssr)
     F                                     PREFIX(J1)
     F                                     RENAME(SDTZLVD0:SDTZLVR2)
 
      ** Time Zone Level Code File 3
     FSDTZLVL5  IF   E           K DISK    INFSR(*Pssr)
 
      ** SD Branch File
     F*SDBRCHL1**UF   E          K DISK    INFSR(*Pssr)                                     BUG21251
     F**********                           RENAME(@A8REB0:SDBRCHUF)                         BUG21251
     FSDBRCHL0  UF   E           K DISK    INFSR(*Pssr)                                     BUG21251
     F                                     RENAME(@A8REB1:SDBRCHUF)                         BUG21251
 
      ** Time Zone History File
     FSDTIZHL0  UF A E           K DISK    INFSR(*Pssr)
     F                                     RENAME(SDTIZHD0:SDTIZHUF)
 
      ** Time Zone Level Code History File
     FSDTZLHL0  UF A E           K DISK    INFSR(*Pssr)
     F                                     RENAME(SDTZLHD0:SDTZLHUF)
 
      ** Daylight Savings Time File
     FSDDSTCL0  UF A E           K DISK    INFSR(*Pssr)
     F                                     RENAME(SDDSTCD0:SDDSTCUF)
      * UPD : Midas SD Branch codes update                                                  BUG21251
      *                                                                                     BUG21251
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)                                     BUG21251
     F                                     COMMIT                                           BUG21251
      *                                                                                     BUG21251
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
      ** External DS for SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** First DS for Access Programs, Short Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PInWeekDay      S              2A
     D PInWeekNum      S              1A
     D PInMonthNum     S              2A
     D PInYearNum      S              4A
     D PInDateFmt      S              1A
     D POutdate5       S              5S 0
     D WkNextStart     S              5S 0
     D WkNextEnd       S              5S 0
     D POutdate6       S              6A
     D WPOutDate5      S              5A
     D WRun            S              1A
     D WDsds           S              3S 0
     D WDsde           S              3S 0
     D WTHDSCD         S              5P 0
     D Timestamp       S             26Z
     D WkYear          S              4S 0
     D WkYearCh        S              4A
     D WkYearCh2       S              4A
     D WTHEFFO         S              4S 0
     D WTHEFFS         S              1
     D WTmp            S              6A
     D WOfSt           S              3S 0 Inz(*ZEROS)
     D WTime           S               T   TIMFMT(*Hms)
     D WTime1          S              6A
     D DSDS            S              3A
     D DSDE            S              3A
     D WkDay           S              2A
     D WkNum           S              1A
     D WkMonth         S              2A
     D K#DSTC          S             10A
     D K#YEAR          S              4A
     D K#YEAR2         S              4A
     D K#YEAR3         S              4A
     D K#TZLC          S              1A
     D K#TZLC2         S              1A
     D K#ZONE          S             10A
     D K#BRCA          S              3A
     D K#BRCA2         S              3A
     D K#MICC          S              4A
     D K#TZCD          S             10A
     D K#DSCD          S              5P 0
     D COMPSDT         S              1A                                                    BUG21195
     D COMPEDT         S              1A                                                    BUG21195
     D WOffset         S              4S 0                                                  BUG21251
     D WSign           S              1A                                                    BUG21251
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Read through DST file, check if the rules are satisfied.
      ** If the rules are satisfied then update/write through DST file
      ** and write old record to history file.
      *
     C     KDstc         KLIST
     C                   KFLD                    K#DSTC
     C                   KFLD                    K#YEAR
      *
     C     KTizo         KLIST
     C                   KFLD                    K#DSTC
      *
     C     KTizo2        KLIST
     C                   KFLD                    K#TZCD
     C                   KFLD                    K#YEAR2
      *
     C     KTzlv3        KLIST
     C                   KFLD                    K#TZLC2
     C                   KFLD                    K#BRCA2
     C                   KFLD                    K#YEAR2
      *
     C     KTzlv2        KLIST
     C                   KFLD                    K#TZLC2
     C                   KFLD                    K#YEAR2
      *
     C     KTzlv5        KLIST
     C                   KFLD                    K#TZCD
     C                   KFLD                    K#YEAR3
      *
     C     *LOVAL        SETLL     SDDSTCL0
     C                   READ      SDDSTCL0
     C                   DOW       NOT (%EOF(SDDSTCL0))
      *
      ** Initialize variables
      *
     C                   EVAL      PInWeekDay   = *Blanks
     C                   EVAL      PInWeekNum   = *Blanks
     C                   EVAL      PInMonthNum  = *Blanks
     C                   EVAL      PInYearNum   = *Blanks
     C                   EVAL      K#YEAR       = *Blanks
     C                   EVAL      K#DSTC = DSDSCD
     C                   EVAL      K#YEAR2 = DSYEAR
     C                   MOVE      DsYear        WkYear
     C                   EVAL      WkYear = WkYear + 1
     C                   MOVE      WkYear        K#YEAR
     C                   MOVE      WkYear        WkYearCh
     C                   MOVE      WkYear        WkYearCh2
      *                                                                                     BUG21195
      ** Check if start/end rule is not equal to zero                                       BUG21195
      *                                                                                     BUG21195
     C                   MOVE      'N'           COMPSDT                                    BUG21195
     C                   IF        DSDSTD <> 0 AND DSDSTW <>0 AND                           BUG21195
     C                             DSDSTM <> 0                                              BUG21195
     C                   MOVE      'Y'           COMPSDT                                    BUG21195
     C                   ENDIF                                                              BUG21195
      *                                                                                     BUG21195
     C                   MOVE      'N'           COMPEDT                                    BUG21195
     C                   IF        DSDEND <> 0 AND DSDENW <>0 AND                           BUG21195
     C                             DSDENM <> 0                                              BUG21195
     C                   MOVE      'Y'           COMPEDT                                    BUG21195
     C                   ENDIF                                                              BUG21195
      *                                                                                     BUG21195
     C                   IF        DSDSDT = 0                                               BUG21195
     C                   EVAL      DSDSDT = BJRDNB                                          BUG21195
     C                   ENDIF                                                              BUG21195
      *
      ** If start date is less than or equal to run date compute
      ** next year start date and end date.
      *
     C                   IF        (DSDSDT <= BJRDNB) AND
     C                             (COMPSDT = 'Y')  AND                                     BUG21195
     C                             DSDIND = *Blanks
     C                   EVAL      WTHDSCD = DSDSDT
     C                   MOVE      DSDSTD        WkDay
     C                   MOVE      DSDSTW        WkNum
     C                   MOVE      DSDSTM        WkMonth
     C                   EXSR      SrFindDate
     C                   EVAL      WkNextStart = POutdate5
      *
     C                   MOVE      DSDEND        WkDay
     C                   MOVE      DSDENW        WkNum
     C                   MOVE      DSDENM        WkMonth
      *
      ** Determine if end date is part of next year
      *
     C                   MOVEL     DSDSTM        DSDS
     C                   MOVE      DSDSTW        DSDS
     C                   MOVE      DSDS          WDSDS
     C                   MOVEL     DSDENM        DSDE
     C                   MOVE      DSDENW        DSDE
     C                   MOVE      DSDE          WDSDE
     C                   IF        WDSDS > WDSDE
     C                   ADD       1             WkYear
     C                   ENDIF
     C                   MOVE      WkYear        WkYearCh2
     C                   EXSR      SrFindDate
      *
     C                   EVAL      WkNextEnd = POutdate5
     C                   EVAL      DSDIND = 'S'
     C                   EVAL      DSLCD = BJRDNB
     C                   EVAL      DSLCT = 'P'
     C                   EVAL      DSUSER = PSUSER
      *
      ** Process DST against Time zone file
      *
     C                   EXSR      SrUpdates
      *
      ** Update DST indicator of the current year
      *
     C                   UPDATE    SDDSTCUF
      *
     C                   EVAL      WPOutDate5 = *Blanks
     C                   MOVE      WkNextStart   WPOutDate5
     C                   MOVE      WPOutDate5    DSDSDT
     C                   EVAL      WPOutDate5 = *Blanks
     C                   MOVE      WkNextEnd     WPOutDate5
     C                   MOVE      WPOutDate5    DSDSED
     C                   EVAL      DSRECI = 'D'
     C                   EVAL      DSYEAR = WkYearCh
     C                   EVAL      DSDIND = *Blanks
     C                   EVAL      DSLCD = BJRDNB
     C                   EVAL      DSLCT = 'P'
     C                   EVAL      DSUSER = PSUSER
      *
      ** Check if record already exist
      *
     C     KDstc         CHAIN     SDDSTCL1
     C                   IF        NOT %FOUND(SDDSTCL1)
     C                   WRITE     SDDSTCUF
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                     BUG21195
     C                   IF        DSDSED = 0                                               BUG21195
     C                   EVAL      DSDSED = BJRDNB                                          BUG21195
     C                   ENDIF                                                              BUG21195
      *
      ** For end date processing
      *
     C                   IF        (DSDSED <= BJRDNB) AND
     C                             (COMPEDT = 'Y')  AND                                     BUG21195
     C                             DSDIND = 'S'
     C                   EVAL      WTHDSCD = DSDSED
     C                   EVAL      DSDIND = 'E'
     C                   EVAL      DSLCD = BJRDNB
     C                   EVAL      DSLCT = 'P'
     C                   EVAL      DSUSER = PSUSER
     C                   EXSR      SrUpdates
     C                   UPDATE    SDDSTCUF
     C                   ENDIF
     C                   READ      SDDSTCL0
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *Pssr                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        (@RTCD <> *BLANKS)
     C     *LOCK         IN        Lda
     C                   EVAL      DbFile = 'SDBANKPD'
     C                   EVAL      Dbkey  = @OPTN
     C                   EVAL      DBPGM  = 'SD001007'
     C                   EVAL      DBase  = 001
     C                   OUT       LDA
     C                   EXSR      *Pssr
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFindDate - Subroutine to get the next start or end date    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrFindDate    BEGSR
      *
     C                   CALLB     'ZFINDDATE'
     C                   PARM      WkDay         PInWeekDay
     C                   PARM      WkNum         PInWeekNum
     C                   PARM      WkMonth       PInMonthNum
     C                   PARM      WkYearCh2     PInYearNum
     C                   PARM      BJDFIN        PInDateFmt
     C                   PARM      *Zero         POutDate5
     C                   PARM      *Blank        POutDate6
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdates - Subroutine to access time zone details which     *
      *              uses the dst code                                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SrUpdates2                                            *
      *                                                               *
      *****************************************************************
      *
     C     SrUpdates     BEGSR
      *
      *
     C     KTizo         SETLL     SDTIZOL2
     C                   READ      SDTIZOL2
     C                   IF        %FOUND(SDTIZOL2)
      *
      ** Process all time zone code which uses the dst code
      *
     C                   DOW       K#DSTC = TZDSTC AND
     C                             NOT (%EOF(SDTIZOL2))
     C                   EVAL      K#TZCD = TZTZCD
     C                   IF        TZYEAR = *Blanks
     C     KTizo2        CHAIN     SDTIZOL1
      *
      ** Check if there is time zone code specific for current yaer
      *
     C                   IF        NOT %FOUND(SDTIZOL1)
     C                   EXSR      SrUpdates2
     C                   ENDIF
     C                   ELSEIF    TZYEAR = DSYEAR
     C                   EXSR      SrUpdates2
     C                   ENDIF
     C                   READ      SDTIZOL2
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdates2 - Subroutine to update time zone history file     *
      *               and process time zone level code file           *
      *                                                               *
      *  Called by: SrUpdates                                         *
      *                                                               *
      *  Calls: SrUpdates3, SrUpdHist                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrUpdates2    BEGSR
      *
      ** Compute offset if trigerred in start date, otherwise
      ** default offset to GMT delta time
      *
     C                   IF        DSDIND = 'S'
     C                   EVAL      WOfSt = DSOFFS
     C                   EVAL      WTHEFFO = TZGMT
     C                   MOVEL     '000000'      WTmp
     C                   MOVEL     WTHEFFO       WTmp
     C                   EVAL      WTime = %Time(WTmp:*Hms0)
     C                   IF        (TZGMTS = '+')
     C                   ADDDUR    WOfSt:*MN     WTime
     C                   ELSE
     C                   SUBDUR    WOfSt:*MN     WTime
     C                   ENDIF
     C                   EVAL      WTime1  = %Char(WTime:*Hms0)
     C                   MOVEL     WTime1        WTHEFFO
     C                   ELSE
     C                   EVAL      WTHEFFO = TZGMT
     C                   ENDIF
     C                   EVAL      WTHEFFS = TZGMTS
      *
     C                   EXSR      SrUpdHist
      *
      ** Process MIC file which uses the time zone code
      *
     C     K#TZCD        SETLL     SDMICCL1
     C                   READ      SDMICCL1
     C                   IF        %FOUND(SDMICCL1)
     C                   DOW       K#TZCD = MITZCD AND
     C                             NOT (%EOF(SDMICCL1))
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   EVAL      TVRECI = 'D'
     C                   EVAL      TVTZLC = 'M'
     C                   EVAL      TVZONE = *BLANKS
     C                   EVAL      TVBRCA = *BLANKS
     C                   EVAL      TVMICC = MICCOD
     C                   EVAL      TVYEAR = DSYEAR
     C                   EVAL      TVTZCD = TZTZCD
     C                   EVAL      TVEFFD = WTHDSCD
     C                   EVAL      TVTMST = TimeStamp
     C                   WRITE     SDTZLHUF
      *
     C                   READ      SDMICCL1
     C                   ENDDO
     C                   ENDIF
     C                   EVAL      K#YEAR3 = *BLANK
     C     KTzlv5        SETLL     SDTZLVL5
     C                   READ      SDTZLVL5
     C                   DOW       NOT (%EOF(SDTZLVL5)) AND
     C                             K#TZCD = TLTZCD
     C                   IF        TLYEAR = *BLANK
     C                   IF        TLTZLC = 'S'
     C                   EVAL      K#TZLC2 = TLTZLC
     C     KTzlv2        CHAIN     SDTZLVL2
     C                   IF        NOT %FOUND(SDTZLVL2)
     C**********         EXSR      SrUpdates3                                               BUG21251
     C                   EXSR      SrUpdates4                                               BUG21251
     C                   ENDIF
     C                   ELSEIF    TLTZLC = 'B'
     C                   EVAL      K#TZLC2 = TLTZLC
     C                   EVAL      K#BRCA2 = TLBRCA
     C     KTzlv3        CHAIN     SDTZLVL3
     C                   IF        NOT %FOUND(SDTZLVL3)
     C                   EXSR      SrUpdates3
     C                   ENDIF
     C                   ENDIF
     C                   ELSEIF    TLYEAR = DSYEAR
     C                   EXSR      SrUpdates3
     C                   ENDIF
     C                   READ      SDTZLVL5
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdates3 - Subroutine to update time zone level code       *
      *               history file and update branch offset/time      *
      *                                                               *
      *  Called by: SrUpdates2                                        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrUpdates3    BEGSR
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   EVAL      TVRECI = 'D'
     C                   EVAL      TVTZLC = TLTZLC
     C                   EVAL      TVZONE = TLZONE
     C                   EVAL      TVBRCA = TLBRCA
     C                   EVAL      TVMICC = *BLANK
     C                   EVAL      TVYEAR = DSYEAR
     C                   EVAL      TVTZCD = TLTZCD
     C                   EVAL      TVEFFD = WTHDSCD
     C                   EVAL      TVTMST = TimeStamp
     C                   WRITE     SDTZLHUF
     C                   EXSR      SrGetOffset                                              BUG21251
     C                   EVAL      K#BRCA = TLBRCA
     C*****K#BRCA        CHAIN     SDBRCHL1                                                 BUG21251
     C**********         IF        %FOUND(SDBRCHL1)                                         BUG21251
     C     K#BRCA        CHAIN     SDBRCHL0                                                 BUG21251
     C                   IF        %FOUND(SDBRCHL0)                                         BUG21251
     C                   IF        TLTZLC = 'B'
     C**********         EVAL      A8TMOF = WTHEFFO                                         BUG21251
     C**********         EVAL      A8SIGN = WTHEFFS                                         BUG21251
     C                   EVAL      A8TMOF = WOffset                                         BUG21251
     C                   EVAL      A8SIGN = WSign                                           BUG21251
     C**********         ELSEIF    TLTZLC = 'S'                                             BUG21251
     C**********         EVAL      A8STOF = WTHEFFO                                         BUG21251
     C**********         EVAL      A8SSIN = WTHEFFS                                         BUG21251
     C                   ENDIF
     C                   UPDATE    SDBRCHUF
     C                   EXSR      SRUpdBrchLog                                             BUG21251
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                BUG21251
      *****************************************************************                     BUG21251
      *                                                               *                     BUG21251
      *  SrUpdates4 - Subroutine to update branch system offset       *                     BUG21251
      *                                                               *                     BUG21251
      *  Called by: SrUpdates2                                        *                     BUG21251
      *                                                               *                     BUG21251
      *  Calls: None                                                  *                     BUG21251
      *                                                               *                     BUG21251
      *****************************************************************                     BUG21251
      *                                                                                     BUG21251
     C     SrUpdates4    BEGSR                                                              BUG21251
      *                                                                                     BUG21251
     C                   EXSR      SrGetOffset                                              BUG21251
      *                                                                                     BUG21251
     C     *LOVAL        SETLL     SDBRCHL0                                                 BUG21251
     C                   READ      SDBRCHL0                                                 BUG21251
     C                   DOW       NOT (%EOF(SDBRCHL0))                                     BUG21251
     C                   EVAL      A8STOF = WOffset                                         BUG21251
     C                   EVAL      A8SSIN = WSign                                           BUG21251
      *                                                                                     BUG21251
     C                   UPDATE    SDBRCHUF                                                 BUG21251
     C                   EXSR      SRUpdBrchLog                                             BUG21251
     C                   READ      SDBRCHL0                                                 BUG21251
     C                   ENDDO                                                              BUG21251
     C                   ENDSR                                                              BUG21251
      *****************************************************************                     BUG21251
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdHist - Subroutine to write out to history file          *
      *                                                               *
      *  Called by: SrUpdates2                                        *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrUpdHist     BEGSR
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   EVAL      THRECI = 'D'
     C                   EVAL      THTZCD = TZTZCD
     C                   EVAL      THYEAR = DSYEAR
     C                   EVAL      THEFFD = WTHDSCD
     C                   EVAL      THDSTC = TZDSTC
     C                   EVAL      THDSTF = TZDSTF
     C                   EVAL      THGMTO = TZGMT
     C                   EVAL      THGMTS = TZGMTS
     C                   EVAL      THDSTS = DSDSDT
     C                   EVAL      THSTIM = DSDSDH
     C                   EVAL      THDSTE = DSDSED
     C                   EVAL      THETIM = DSDENH
     C                   EVAL      THDSTO = DSOFFS
     C                   EVAL      THTMST = TimeStamp
     C                   EVAL      THEFFO = WTHEFFO
     C                   EVAL      THEFFS = WTHEFFS
     C                   EVAL      THTYLC = 'P'
     C                   WRITE     SDTIZHUF
      *
     C                   ENDSR
      *
      *****************************************************************                     BUG21251
      /EJECT                                                                                BUG21251
      *****************************************************************                     BUG21251
      *                                                               *                     BUG21251
      *  SRUpdBrchLog - Update branch trailer file for any changes    *                     BUG21251
      *                                                               *                     BUG21251
      *  Called by:                                                   *                     BUG21251
      *                                                               *                     BUG21251
      *  Calls: TABLETR, ZASNMS                                       *                     BUG21251
      *                                                               *                     BUG21251
      *****************************************************************                     BUG21251
     C     SRUpdBrchLog  BEGSR                                                              BUG21251
      *                                                                                     BUG21251
     C                   MOVEL     *BLANK        W0RTN             7                        BUG21251
      *                                                                                     BUG21251
      ** Move key fields to @AHREAU                                                         BUG21251
     C                   MOVEL     'SDBRCHPD'    Filename         10                        BUG21251
      *                                                                                     BUG21251
     C     Filename      CHAIN     SDFCTLL0                                                 BUG21251
     C                   IF        %Found(SDFCTLL0)                                         BUG21251
      ** Increment number of Amendments.                                                    BUG21251
     C                   EVAL      AHNOAM = AHNOAM + 1                                      BUG21251
     C                   UPDATE    @AHREAU                                                  BUG21251
     C                   UNLOCK    SDFCTLL0                                                 BUG21251
     C                   ENDIF                                                              BUG21251
      ** TABLETR - Branch Codes  *                                                          BUG21251
     C                   CALL      'TABLETR'                            90                  BUG21251
     C     W0RTN         PARM      *BLANK        WQ0041            7                        BUG21251
     C                   PARM      A8BRCD        WQ0042            3                        BUG21251
     C                   PARM      A8CMCD        WQ0043            3                        BUG21251
     C                   PARM      A8LCCD        WQ0044            3                        BUG21251
     C                   PARM      A8DFAC        WQ0045            4                        BUG21251
     C                   PARM      A8DTAC        WQ0046            4                        BUG21251
     C                   PARM      A8BICN        WQ0047            6                        BUG21251
     C                   PARM      A8LCD         WQ0048            5 0                      BUG21251
     C                   PARM      A8TYLC        WQ0049            1                        BUG21251
     C                   PARM      A8BRNM        WQ0050           30                        BUG21251
     C                   PARM      A8GBCD        WQ0051            3                        BUG21251
     C                   PARM      A8BRSN        WQ0052            3                        BUG21251
      *                                                                                     BUG21251
     C                   IF        *IN90 = False And W0RTN = *Blanks                        BUG21251
     C                   COMMIT                                                             BUG21251
     C                   ELSE                                                               BUG21251
     C                   ROLBK                                                              BUG21251
     C                   ENDIF                                                              BUG21251
      *                                                                                     BUG21251
     C                   ENDSR                                                              BUG21251
      *****************************************************************                     BUG21251
      *                                                               *                     BUG21251
      *  SrGetOffset - This subroutine determines new effective       *                     BUG21251
      *                offset for the branch                          *                     BUG21251
      *  Calls: None                                                  *                     BUG21251
      *                                                               *                     BUG21251
      *****************************************************************                     BUG21251
      *                                                                                     BUG21251
     C     SrGetOffset   BEGSR                                                              BUG21251
      *                                                                                     BUG21251
      *                                                                                     BUG21251
     C                   IF        BJRDNB >= DSDSDT   AND                                   BUG21251
     C                             BJRDNB < DSDSED                                          BUG21251
      *                                                                                     BUG21251
     C                   EVAL      WOfSt = DSOFFS                                           BUG21251
     C                   EVAL      WOffset = TZGMT                                          BUG21251
     C                   MOVEL     '000000'      WTmp                                       BUG21251
     C                   MOVEL     WOffset       WTmp                                       BUG21251
     C                   EVAL      WTime = %Time(WTmp:*Hms0)                                BUG21251
     C                   IF        (TZGMTS = '+')                                           BUG21251
     C                   ADDDUR    WOfSt:*MN     WTime                                      BUG21251
     C                   ELSE                                                               BUG21251
     C                   SUBDUR    WOfSt:*MN     WTime                                      BUG21251
     C                   ENDIF                                                              BUG21251
     C                   EVAL      WTime1  = %Char(WTime:*Hms0)                             BUG21251
     C                   MOVEL     WTime1        WOffset                                    BUG21251
     C                   ELSE                                                               BUG21251
     C                   EVAL      WOffset = TZGMT                                          BUG21251
     C                   ENDIF                                                              BUG21251
     C                   EVAL      WSign   = TZGMTS                                         BUG21251
     C                                                                                      BUG21251
     C                   ENDSR                                                              BUG21251
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *Pssr  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using Exsr.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *Pssr         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
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
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2007

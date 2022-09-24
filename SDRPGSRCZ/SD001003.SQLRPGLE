     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD058085
/*STD *  RPGSQLMOD                                                    *                     MD058085
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD058085
/*EXI *  TEXT('Midas SD CSW208 Initialisation Program 3')
      *****************************************************************
      *                                                               *
      *  Midas - MIDAS Common Routines                                *
      *                                                               *
      *  SD001003 - Midas SD CSW208 Initialisation Program 3          *
      *                                                               *
      *  Function:  This module will project the next 2 years of      *
      *             DST with its future start date and end date.      *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG20226           Date 15Aug08               *
      *                 BUG19758           Date 03Jul08               *
      *                 BUG20220A          Date 25Jul08               *
      *                 BUG20220           Date 24Jul08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG20226 - Database error occurred during "Copy" mode        *
      *             (Recompile)                                       *
      *  BUG19758 - Various errors                                    *
      *  BUG20220A - Duplicate Key Error in SDC001003(Reopened)       *
      *  BUG20220 - Duplicate Key Error in SDC001003                  *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *Pssr    - Error Processing                                  *
      *  *INZSR   - Program Initialisation Routine                    *
      *  SrFindDate - Subroutine to get the next start or end date    *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Daylight Savings Time File
     F*SDDSTCL1* IF   E           K DISK    INFSR(*Pssr)                                    MD058085

      ** Daylight Savings Time File
     F*SDDSTCL0* UF A E           K DISK    INFSR(*Pssr)                                    MD058085
     F**********                           RENAME(SDDSTCD0:SDDSTCUF)                        MD058085

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

     D SDDSTC        E DS                  EXTNAME(SDDSTJW0)                                MD058085
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
     D WPOutDate5S     S              5A
     D WPOutDate5E     S              5A
     D WRun            S              1A
     D WDsds           S              3S 0
     D WDsde           S              3S 0
     D WkYear          S              4S 0
     D WkYearCh        S              4A
     D WkYearCh2       S              4A                                                    BUG19758
     D YEARNUM         S              1S 0
     D DSDS            S              3A
     D DSDE            S              3A
     D WkDay           S              2A
     D WkNum           S              1A
     D WkMonth         S              2A
     D DSDSCD2         S             10A
     D MainRec         S              1A
     D K#DSCD          S             10A
     D K#YEAR          S              4A

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
     C     KDSTC         KLIST
     C                   KFLD                    K#DSCD
     C                   KFLD                    K#YEAR
      *
     C                   EVAL      DSDSCD2 = *Blanks
     C******LOVAL        SETLL     SDDSTCL1                                                 MD058085
     C**********         READ      SDDSTCL1                                                 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ declare ACursor insensitive scroll cursor for                                       MD058085
     C+ select * from SDDSTJW0                                                              MD058085
     C+ where DSRECI = 'D'                                                                  MD058085
     C+ order by DSDSCD, DSYEAR                                                             MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ open ACursor                                                                        MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDDSTC                                                MD058085
     C/END-EXEC                                                                             MD058085
     C**********         DOW       NOT (%EOF(SDDSTCL1))                                     MD058085
     C                   DOW       SQLCODE = 0                                              MD058085
      *
      ** Look for next DST code
      *
     C**********         IF        DSDSCD <> DSDSCD2                                       BUG20220A
     C                   IF        DSDSCD <> DSDSCD2  And DSUSER = *Blanks                 BUG20220A
     C                   EVAL      MainRec = 'Y'
     C                   EVAL      YEARNUM = 0
      *
      ** Project next 2 years of DST file
      *
     C                   DOW       YEARNUM <= 2
      *
      ** Initialize variables
      *
     C                   EVAL      PInWeekDay   = *Blanks
     C                   EVAL      PInWeekNum   = *Blanks
     C                   EVAL      PInMonthNum  = *Blanks
     C                   EVAL      PInYearNum   = *Blanks
     C                   MOVE      DsYear        WkYear
     C                   IF        MainRec = 'N'
     C                   EVAL      WkYear = WkYear + 1
     C                   ENDIF
     C                   MOVE      WkYear        WkYearCh
     C                   MOVE      WkYear        WkYearCh2                                  BUG19758
      *
      ** For main record, process start date only if it is blank
      ** Otherwise, always find start date
      *
     C                   IF        MainRec = 'Y' AND
     C                             DSDSDT = *Zero OR
     C                             MainRec = 'N'
     C                   MOVE      DSDSTD        WkDay
     C                   MOVE      DSDSTW        WkNum
     C                   MOVE      DSDSTM        WkMonth
      *
     C                   EXSR      SrFindDate
      *
     C                   EVAL      WkNextStart = POutdate5
     C                   EVAL      WPOutDate5S = *Blanks
     C                   MOVE      WkNextStart   WPOutDate5S
     C                   MOVE      WPOutDate5S   DSDSDT
     C                   ENDIF
      *
      ** For main record, process end date only if it is blank
      ** Otherwise, always find end date
      *
     C                   IF        MainRec = 'Y' AND
     C                             DSDSED = *Zero OR
     C                             MainRec = 'N'
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
     C                   MOVE      WkYear        WkYearCh2                                  BUG19758
     C                   ENDIF
     C                   EXSR      SrFindDate
     C                   EVAL      WkNextEnd = POutdate5
     C                   EVAL      WPOutDate5E = *Blanks
     C                   MOVE      WkNextEnd     WPOutDate5E
     C                   MOVE      WPOutDate5E   DSDSED
     C                   ENDIF
      *
      ** Move the values for output
      *
     C                   IF        MainRec = 'Y'
     C                   EVAL      K#DSCD = DSDSCD
     C                   EVAL      K#YEAR = WkYearCh
     C*****KDSTC         CHAIN     SDDSTCL0                                                 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDDSTC                                                                        MD058085
     C+ from SDDSTJW0                                                                       MD058085
     C+ where DSDSCD = :K#DSCD and DSYEAR = :K#YEAR                                         MD058085
     C/END-EXEC                                                                             MD058085
     C                   IF        SQLCODE = 0                                              MD058085
     C**********         IF        %FOUND(SDDSTCL0)                                         MD058085
     C                   IF        DSDSDT = *Zero
     C                   MOVE      WPOutDate5S   DSDSDT
     C                   ENDIF
     C                   IF        DSDSED = *Zero
     C                   MOVE      WPOutDate5E   DSDSED
     C                   ENDIF
     C                   EVAL      DSDSDH = 020000                                          BUG20220
     C                   EVAL      DSDENH = 020000                                          BUG20220
     C**********         UPDATE    SDDSTCUF                                                 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ update SDDSTXTD set                                                                 MD058085
     C+   DSDSDT = :DSDSDT                                                                  MD058085
     C+  ,DSDSDH = :DSDSDH                                                                  MD058085
     C+  ,DSDSED = :DSDSED                                                                  MD058085
     C+  ,DSDENH = :DSDENH                                                                  MD058085
     C+ where DSDSCD = :K#DSCD and DSYEAR = :K#YEAR                                         MD058085
     C/END-EXEC                                                                             MD058085
     C                   ENDIF
     C                   EVAL      MainRec = 'N'
     C                   ELSE
     C                   EVAL      DSRECI = 'D'
     C                   EVAL      DSYEAR = WkYearCh
     C                   EVAL      DSDIND = *Blanks
     C                   EVAL      DSLCD = *Zero
     C                   EVAL      DSLCT = *Blanks
     C                   EVAL      DSUSER = *Blanks
     C                   EVAL      K#YEAR = WkYearCh                                        BUG20220
     C*****KDSTC         CHAIN     SDDSTCL0                                                 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDDSTC                                                                        MD058085
     C+ from SDDSTJW0                                                                       MD058085
     C+ where DSDSCD = :K#DSCD and DSYEAR = :K#YEAR                                         MD058085
     C/END-EXEC                                                                             MD058085
     C                   IF        SQLCODE = 100                                            MD058085
     C**********         IF        NOT(%FOUND(SDDSTCL0))                                    BUG20220
     C**********         WRITE     SDDSTCUF                                                 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ insert into SDDSTBTD                                                                MD058085
     C+ (                                                                                   MD058085
     C+   DSRECI                                                                            MD058085
     C+  ,DSDSCD                                                                            MD058085
     C+  ,DSYEAR                                                                            MD058085
     C+  ,DSDESC                                                                            MD058085
     C+  ,DSOFFS                                                                            MD058085
     C+  ,DSDSDT                                                                            MD058085
     C+  ,DSDSDH                                                                            MD058085
     C+  ,DSDSTM                                                                            MD058085
     C+  ,DSDSTW                                                                            MD058085
     C+  ,DSDSTD                                                                            MD058085
     C+  ,DSDSED                                                                            MD058085
     C+  ,DSDENH                                                                            MD058085
     C+  ,DSDENM                                                                            MD058085
     C+  ,DSDENW                                                                            MD058085
     C+  ,DSDEND                                                                            MD058085
     C+  ,DSDIND                                                                            MD058085
     C+  ,DSLCD                                                                             MD058085
     C+  ,DSLCT                                                                             MD058085
     C+  ,DSUSER                                                                            MD058085
     C+  ,DSMODE                                                                            MD058085
     C+ )                                                                                   MD058085
     C+ Values                                                                              MD058085
     C+ (                                                                                   MD058085
     C+   :DSRECI                                                                           MD058085
     C+  ,:DSDSCD                                                                           MD058085
     C+  ,:DSYEAR                                                                           MD058085
     C+  ,' '                                                                               MD058085
     C+  ,' '                                                                               MD058085
     C+  ,:DSDSDT                                                                           MD058085
     C+  ,:DSDSDH                                                                           MD058085
     C+  ,' '                                                                               MD058085
     C+  ,' '                                                                               MD058085
     C+  ,' '                                                                               MD058085
     C+  ,:DSDSED                                                                           MD058085
     C+  ,:DSDENH                                                                           MD058085
     C+  ,' '                                                                               MD058085
     C+  ,' '                                                                               MD058085
     C+  ,' '                                                                               MD058085
     C+  ,' '                                                                               MD058085
     C+  ,0                                                                                 MD058085
     C+  ,0                                                                                 MD058085
     C+  ,' '                                                                               MD058085
     C+  ,'B'                                                                               MD058085
     C+ )                                                                                   MD058085
     C/END-EXEC                                                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ insert into SDDSTXTD                                                                MD058085
     C+ (                                                                                   MD058085
     C+   DSRECI                                                                            MD058085
     C+  ,DSDSCD                                                                            MD058085
     C+  ,DSYEAR                                                                            MD058085
     C+  ,DSDESC                                                                            MD058085
     C+  ,DSOFFS                                                                            MD058085
     C+  ,DSDSDT                                                                            MD058085
     C+  ,DSDSDH                                                                            MD058085
     C+  ,DSDSTM                                                                            MD058085
     C+  ,DSDSTW                                                                            MD058085
     C+  ,DSDSTD                                                                            MD058085
     C+  ,DSDSED                                                                            MD058085
     C+  ,DSDENH                                                                            MD058085
     C+  ,DSDENM                                                                            MD058085
     C+  ,DSDENW                                                                            MD058085
     C+  ,DSDEND                                                                            MD058085
     C+  ,DSDIND                                                                            MD058085
     C+  ,DSLCD                                                                             MD058085
     C+  ,DSLCT                                                                             MD058085
     C+  ,DSUSER                                                                            MD058085
     C+  ,DSMODE                                                                            MD058085
     C+ )                                                                                   MD058085
     C+ Values                                                                              MD058085
     C+ (                                                                                   MD058085
     C+   :DSRECI                                                                           MD058085
     C+  ,:DSDSCD                                                                           MD058085
     C+  ,:DSYEAR                                                                           MD058085
     C+  ,' '                                                                               MD058085
     C+  ,' '                                                                               MD058085
     C+  ,:DSDSDT                                                                           MD058085
     C+  ,:DSDSDH                                                                           MD058085
     C+  ,' '                                                                               MD058085
     C+  ,' '                                                                               MD058085
     C+  ,' '                                                                               MD058085
     C+  ,:DSDSED                                                                           MD058085
     C+  ,:DSDENH                                                                           MD058085
     C+  ,' '                                                                               MD058085
     C+  ,' '                                                                               MD058085
     C+  ,' '                                                                               MD058085
     C+  ,' '                                                                               MD058085
     C+  ,0                                                                                 MD058085
     C+  ,0                                                                                 MD058085
     C+  ,' '                                                                               MD058085
     C+  ,'B'                                                                               MD058085
     C+ )                                                                                   MD058085
     C/END-EXEC                                                                             MD058085
     C                   ENDIF                                                              BUG20220
     C                   ENDIF
      *
     C                   EVAL      YEARNUM = YEARNUM + 1
     C                   EVAL      DSDSCD2 = DSDSCD
     C                   ENDDO
     C                   ENDIF
      *
     C**********         READ      SDDSTCL1                                                 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDDSTC                                                MD058085
     C/END-EXEC                                                                             MD058085
      *
     C                   ENDDO
      *
     C/EXEC SQL                                                                             MD058085
     C+ close ACursor                                                                       MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
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
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDBANKPD'
     C                   EVAL      Dbkey  = @OPTN
     C                   EVAL      DBPGM  = 'SD001003'
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
     C**********         PARM      WkYearCh      PInYearNum                                 BUG19758
     C                   PARM      WkYearCh2     PInYearNum                                 BUG19758
     C                   PARM      BJDFIN        PInDateFmt
     C                   PARM      *Zero         POutDate5
     C                   PARM      *Blank        POutDate6
      *
     C                   ENDSR
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
(c) Finastra International Limited 2007

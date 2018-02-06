     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas CB Check Unauthorised Transaction')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  CB001001 - Midas COB Check Unauthorised Transaction          *
      *                                                               *
      *  Function:  This new program will check any unauthorised      *
      *             transaction after user confirm with 'Y' to message*
      *             'Please confirm that you wish to begin close      *
      *             of business processing'. It will be called after  *
      *             checking of message in MSTATUS return with *BLANK.*
      *                                                               *
      *  Called By: SCC0400 - Input cycle termination                 *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE164             Date 18Aug14               *
      *                 MD021155           Date 19Jul13               *
      *                 MD020661A          Date 19Jun13               *
      *                 MD020661           Date 28May13               *
      *                 AR1092065          Date 26Feb13               *
      *                 AR1091294          Date 26Feb13               *
      *                 AR1089839          Date 19Feb13               *
      *                 CCB023   *CREATE   Date 06Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  MD021155 - COB Restructure Phase 1 remnants                  *
      *           - Dashboard Problems                                *
      *           - Locking on SDSVALPD and SDAPIPD                   *
      *  MD020661A - DCUATH field should be Y or N (Reopen)           *
      *  MD020661 - DCUATH field should be Y or N (Recompile)         *
      *  AR1092065 - COB proceeded and continue running bypassing the *
      *              initial error regarding unauthorized transactions*
      *  AR1091294 - Error upon starting COB                          *
      *  AR1089839 - COBOP and 2.1 source clashes                     *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
     FCB001001DFCF   E             WORKSTN
     F                                     SFILE(CB001001F1:RCNTR)
     F***SDAPIPD   IF   E             DISK    INFSR(*PSSR)                                  MD021155
     F***SDSVALL0  IF   E           K DISK    INFSR(*PSSR)                                  MD021155
      *
      ** GPDWNLPD data structure
      *
     D RTNVL           S              1A
     D GPDWNLLDS     E DS                   EXTNAME(V_DASHACTN)
     D                                      INZ                                            AR1091294
      *
      ** Program Status Data Structure - gives Job and User ID.
      *
     D PSDS           SDS
     D  JOB                  244    253
     D  USER                 254    263
      *
      ** Declared Constants
      *
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     DINVAPI           C                   Const('UnrepRPGInvalidAPI  ')
     DVLDAPI           C                   Const('UnrepRPGValidAPI    ')
     DWTRANS           C                   CONST('WaitTransOutMsg     ')
     DWTRCDL           C                   CONST('WaitRCDownload      ')
     DSVALSFT          C                   CONST('ReopenSwiftTrans    ')
     DSVALREC          C                   CONST('ReopenAutoRecs      ')
     DRUNBFOR          S              1
     D SDSTAT        E DS           256    EXTNAME(SDSTAT) DTAARA(SDSTAT)                  AR1089839
     D  SYSID                  6      7                                                    AR1089839
                                                                                            MD021155
      ** Define system values parameters.                                                   MD021155
                                                                                            MD021155
     D PRtcd           S              7A                                                    MD021155
     D PSysVal01       S             20A                                                    MD021155
     D PCurSet01       S            200A                                                    MD021155
     D PSysVal02       S             20A                                                    MD021155
     D PCurSet02       S            200A                                                    MD021155
     D PSysVal03       S             20A                                                    MD021155
     D PCurSet03       S            200A                                                    MD021155
     D PSysVal04       S             20A                                                    MD021155
     D PCurSet04       S            200A                                                    MD021155
     D PSysVal05       S             20A                                                    MD021155
     D PCurSet05       S            200A                                                    MD021155
     D PSysVal06       S             20A                                                    MD021155
     D PCurSet06       S            200A                                                    MD021155
     D PSysVal07       S             20A                                                    MD021155
     D PCurSet07       S            200A                                                    MD021155
     D PSysVal08       S             20A                                                    MD021155
     D PCurSet08       S            200A                                                    MD021155
     D PSysVal09       S             20A                                                    MD021155
     D PCurSet09       S            200A                                                    MD021155
     D PSysVal10       S             20A                                                    MD021155
     D PCurSet10       S            200A                                                    MD021155
                                                                                            MD021155
     ** Define variables for API ICD                                                        MD021155
                                                                                            MD021155
     D POptn           S              7A                                                    MD021155
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                                 MD021155
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD021155
     D GPDWNL        E DS                  EXTNAME(GPDWNLPD) INZ                              CLE164
     D                                     PREFIX(MX_)                                        CLE164
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE164
     D CLE134          S              1A                                                      CLE164
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    RTNVL

      *                                                                                    AR1089839
      ** Retrieve System ID                                                                AR1089839
      *                                                                                    AR1089839
     C     *LOCK         IN        SDSTAT                                                  AR1089839
     C                   OUT       SDSTAT                                                  AR1089839
                                                                                           AR1089839
     C     START         TAG

     C                   EVAL      *IN04 = *OFF
     C                   EVAL      *IN10 = *OFF
     C**********         EVAL      *IN98 = *OFF                                             MD021155
     C**********         EVAL      *IN99 = *OFF                                             MD021155
     C                   EVAL      *IN09 = *OFF
      *
      ** Select all records from GPDWNLPD where DLVAL <> 0 and <> ' '
      ** and DLKEYD = 'Unauth%' or = 'BatchesNotAccepted'
      ** or  DLKEYD = 'Unrep%' or = 'Wait%'
      *
     C/EXEC SQL
     C+ declare
     C+     GPDCUR insensitive scroll cursor for
     C+ select * from V_DASHACTN
     C+ where
     C*+*****DLUATH = 'Y'                                                                  MD020661A
     C*+*****and DLVAL <> 0                                                                MD020661A
     C+     DLVAL <> 0                                                                     MD020661A
     C+     and DLMSID = :SYSID                                                            AR1089839
     C/END-EXEC
      *
      ** OPEN cursor to retrieve total number of
      ** rows of GPDWNLPD and for FETCH
      *
     C/EXEC SQL
     C+ open GPDCUR
     C/END-EXEC

     C     SQLCODE       IFEQ      SQLOK

     C**********         WRITE     CB001001F0                                               MD021155
     C**********         WRITE     CB001001F3                                               MD021155
     C                   EVAL      *IN01 = *ON
     C                   EVAL      *IN02 = *ON
     C                   EVAL      *IN04 = *ON
     C                   Z-ADD     1             RCNTR             4 0

     C                   DOU       SQLCODE <> SQLOK
     C                             and SQLCODE = SQLEOF                                    AR1091294
      *
      ** FETCH by batch of ULROWS into GLACBTDS and determine
      ** number of rows retrieved for this batch
      *
     C/EXEC SQL
     C+ fetch next from GPDCUR into :GPDWNLLDS
     C/END-EXEC

     C                   MOVEL     DLVAL         DSVAL
     C                   MOVEL     DLKEYD        DSKEYD

     C                   IF        SQLCODE <> SQLOK
     C                   LEAVE
     C                   ENDIF

     C                   SELECT
     C     DLKEYD        WHENEQ    INVAPI
     C     DLKEYD        OREQ      VLDAPI

     C                   EXSR      APIRTN

     C     DLKEYD        WHENEQ    WTRANS
     C     DLKEYD        OREQ      WTRCDL

     C                   EXSR      SYSVAL

     C                   OTHER

     C                   IF        DLUATH = 'W'                                            MD020661A
                                                                                           MD020661A
     C                   EVAL      WRNING = '**Warning**'                                  MD020661A
                                                                                           MD020661A
     C                   IF        *IN09 = *OFF                                            MD020661A
     C                   EVAL      *IN10 = *ON                                             MD020661A
     C                   ENDIF                                                             MD020661A
     C                   WRITE     CB001001F1                                              MD020661A
     C                   ADD       1             RCNTR                                     MD020661A
                                                                                           MD020661A
     C                   ELSE                                                              MD020661A
                                                                                           MD020661A
     C                   EVAL      WRNING = *BLANKS                                        MD020661A
                                                                                           MD020661A
     C                   EVAL      *IN10 = *OFF
     C                   EVAL      *IN09 = *ON
     C                   WRITE     CB001001F1
     C                   ADD       1             RCNTR

     C                   ENDIF                                                             MD020661A
     C                   ENDSL

     C                   ENDDO
                                                                                              CLE164
     C                   EXSR      SRMTRX                                                     CLE164
                                                                                              CLE164
      *
      ** Close cursor fetch
      *
     C/EXEC SQL
     C+ close GPDCUR
     C/END-EXEC

     C**********         IF        DSVAL <> *BLANKS                                        AR1091294
     C                   IF        DLVAL <> *ZEROS                                         AR1091294

     C                   EVAL      DLVAL = *ZEROS                                          AR1092065
     C                   EXSR      SHWSCRN

     C                   ENDIF

     C                   ENDIF

     C                   IF        *INKC = *ON

     C******IN09         IFNE      *ON                                                     AR1092065
     C******IN10         ORNE      *ON                                                     AR1092065

     C                   EVAL      *INKC = *OFF                                            AR1092065
     C                   EVAL      RTNVL = 'R'
     C                   RETURN                                                            AR1092065

     C                   ELSE

     C**********         EVAL      RTNVL = 'N'                                             AR1092065
                                                                                           AR1092065
     C                   IF        *IN10 = *ON  OR                                         AR1092065
     C                             *IN09 = *OFF AND                                        AR1092065
     C                             *IN10 = *OFF                                            AR1092065
     C                   RETURN                                                            AR1092065

     C                   ENDIF

     C                   ENDIF

     C******IN09         IFEQ      *OFF                                                    AR1092065
     C*****RTNVL         OREQ      'R'                                                     AR1092065

     C**********         RETURN                                                            AR1092065

     C**********         ENDIF                                                             AR1092065
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SHWSCRN - This routine will execute the screen format when-  *
      *            ever there is/are unauthorised records.            *
      *****************************************************************
     C     SHWSCRN       BEGSR

     C                   WRITE     CB001001F0
     C                   WRITE     CB001001F3
     C                   EXFMT     CB001001F2
     C                   EVAL      *IN01 = *OFF
     C                   EVAL      *IN02 = *OFF
     C                   WRITE     CB001001F2

     C                   IF        *INKE = *ON

     C*****1****         SETLL     SDAPIPD                                        AR1089839 MD021155
     C                   EVAL      WRNING = *BLANKS
     C**********         READ      SDAPIPD                                99                MD021155
     C                   GOTO      START

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SYSVAL - This routine will retrieve GISVAL and GIVAL from    *
      *           SDSVALPD where GIVAL = 'N'.                         *
      *****************************************************************
     C     SYSVAL        BEGSR

     C                   EVAL      PSysVal01 = SVALSFT                                      MD021155
     C                   EVAL      PSysVal02 = SVALREC                                      MD021155
                                                                                            MD021155
     C                   CALL      'AOSVALR0'                                               MD021155
     C                   PARM      *BLANKS       PRtCd                                      MD021155
     C                   PARM                    PSysVal01                                  MD021155
     C                   PARM                    PCurSet01                                  MD021155
     C                   PARM                    PSysVal02                                  MD021155
     C                   PARM                    PCurSet02                                  MD021155
     C                   PARM                    PSysVal03                                  MD021155
     C                   PARM                    PCurSet03                                  MD021155
     C                   PARM                    PSysVal04                                  MD021155
     C                   PARM                    PCurSet04                                  MD021155
     C                   PARM                    PSysVal05                                  MD021155
     C                   PARM                    PCurSet05                                  MD021155
     C                   PARM                    PSysVal06                                  MD021155
     C                   PARM                    PCurSet06                                  MD021155
     C                   PARM                    PSysVal07                                  MD021155
     C                   PARM                    PCurSet07                                  MD021155
     C                   PARM                    PSysVal08                                  MD021155
     C                   PARM                    PCurSet08                                  MD021155
     C                   PARM                    PSysVal09                                  MD021155
     C                   PARM                    PCurSet09                                  MD021155
     C                   PARM                    PSysVal10                                  MD021155
     C                   PARM                    PCurSet10                                  MD021155

     C     DLKEYD        IFEQ      WTRANS

     C*****SVALSFT       CHAIN     SDSVALL0                           97                    MD021155

     C******IN97         IFEQ      *OFF                                                     MD021155
     C*****GIVAL         ANDEQ     'N'                                                      MD021155
     C                   IF        PRtCd = *BLANKS                                          MD021155
     C                             AND PCurSet01 = 'N'                                      MD021155

     C                   EVAL      WRNING = '**Warning**'

     C                   IF        *IN09 = *OFF
     C                   EVAL      *IN10 = *ON
     C                   ENDIF

     C                   ENDIF

     C                   ELSE

     C*****SVALREC       CHAIN     SDSVALL0                           98                    MD021155

     C******IN98         IFEQ      *OFF                                                     MD021155
     C*****GIVAL         ANDEQ     'N'                                                      MD021155
     C                   IF        PRtCd = *BLANKS                                          MD021155
     C                             AND PCurSet02 = 'N'                                      MD021155

     C                   EVAL      WRNING = '**Warning**'

     C                   IF        *IN09 = *OFF
     C                   EVAL      *IN10 = *ON
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   IF        WRNING <> *BLANKS

     C                   WRITE     CB001001F1
     C**********         EVAL      DLVAL = *ZERO                                           AR1092065
     C                   ADD       1             RCNTR
     C                   EVAL      WRNING = *BLANKS

     C                   ELSE

     C                   WRITE     CB001001F1
     C**********         EVAL      DLVAL = *ZERO                                           AR1092065
     C                   EVAL      *IN09 = *ON                                             AR1092065
     C                   ADD       1             RCNTR

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  APIRTN - This routine will select GHHTIN and GHHTVL from     *
      *           SDAPIPD where GHHTIN = 'N' or GHHTVL = 'N'.         *
      *****************************************************************
     C     APIRTN        BEGSR

     C******IN99         IFEQ      *OFF                                                     MD021155

     C*****1****         SETLL     SDAPIPD                                        AR1092065 MD021155
     C**********         READ      SDAPIPD                                99                MD021155

     C**********         EVAL      *IN99 = *ON                                              MD021155

     C**********         ENDIF                                                              MD021155
     C                   CALL      'AOAPIR0'                                                MD021155
     C                   PARM      *BLANKS       PRtCd                                      MD021155
     C                   PARM      '*FIRST '     POptn                                      MD021155
     C     SDAPI         PARM      SDAPI         DSFDY                                      MD021155
                                                                                            MD021155
     C     PRtCd         IFNE      *BLANKS                                                  MD021155
     C                   EXSR      *PSSR                                                    MD021155
     C                   ENDIF                                                              MD021155

     C     DLKEYD        IFEQ      INVAPI
     C     GHHTIN        ANDEQ     'N'

     C                   EVAL      WRNING = '**Warning**'

     C                   IF        *IN09 = *OFF
     C                   EVAL      *IN10 = *ON
     C                   ENDIF

     C                   ENDIF

     C     DLKEYD        IFEQ      VLDAPI
     C     GHHTVL        ANDEQ     'N'

     C                   EVAL      WRNING = '**Warning**'

     C                   IF        *IN09 = *OFF
     C                   EVAL      *IN10 = *ON
     C                   ENDIF

     C                   ENDIF

     C                   IF        WRNING <> *BLANKS

     C                   WRITE     CB001001F1
     C**********         EVAL      DLVAL = *ZERO                                           AR1092065
     C                   ADD       1             RCNTR
     C                   EVAL      WRNING = *BLANKS

     C                   ELSE

     C                   WRITE     CB001001F1
     C**********         EVAL      DLVAL = *ZERO                                           AR1092065
     C                   EVAL      *IN09 = *ON                                             AR1092065
     C                   ADD       1             RCNTR

     C                   ENDIF

     C                   ENDSR
      *****************************************************************                       CLE164
      *                                                               *                       CLE164
      *    SRMTRX - Dashboard for PDP Repayment Matrix                *                       CLE164
      *                                                               *                       CLE164
      *****************************************************************                       CLE164
     C     SRMTRX        BEGSR                                                                CLE164
                                                                                              CLE164
     C                   CALL      'AOSARDR0'                                                 CLE164
     C                   PARM      *BLANKS       PRtCd                                        CLE164
     C                   PARM      '*VERIFY'     POptn                                        CLE164
     C                   PARM      'CLE134'      PSard             6                          CLE164
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE164
                                                                                              CLE164
     C                   IF        PRtCd = *Blank                                             CLE164
     C                   EVAL      CLE134 = 'Y'                                               CLE164
     C                   ELSE                                                                 CLE164
     C                   EVAL      CLE134 = 'N'                                               CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   IF        CLE134 = 'N'                                               CLE164
     C                   LEAVESR                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C/EXEC SQL                                                                               CLE164
     C+ select * into :GPDWNL from GPDWNLPD where                                             CLE164
     C+ DLMSID = :SYSID and DLKEYD = 'PDPRepMatrixBulkUpd'                                    CLE164
     C/END-EXEC                                                                               CLE164
                                                                                              CLE164
     C                   IF        SQLCOD = 0                                                 CLE164
     C                   EVAL      DSVAL = MX_DLVAL                                           CLE164
     C                   EVAL      DSKEYD = MX_DLKEYD                                         CLE164
     C                   EVAL      DLUATH = 'Y'                                               CLE164
     C                   IF        DSVAL = 'Y'                                                CLE164
     C                   EVAL      *IN09 = *ON                                                CLE164
     C                   EVAL      *IN10 = *OFF                                               CLE164
     C                   WRITE     CB001001F1                                                 CLE164
     C                   ADD       1             RCNTR                                        CLE164
     C                   ENDIF                                                                CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        RUNBFOR = *BLANK
     C                   EVAL      RUNBFOR = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************

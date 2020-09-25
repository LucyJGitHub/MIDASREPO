     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SC Trigger Program for CoB Opt Manager')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC001003 - Midas SC Trigger Program for CoB Optimisation     *
      *             Manager                                           *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. CUP040             Date 06Mar14               *
      *                 MD024412           Date 04Feb14               *
      *                 AR1090366          Date 21Feb13               *
      *                 CCB022A *REWRITE   Date 06Aug12               *
      *                 CCB022  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  CUP040 - Restructure of deliverable data files.              *
      *  MD024412 - Additional changes for COM processing             *
      *  AR1090366 - Deliverable data for SCCOMMTD and SCCOMXTD       *
      *            - were delivered, files are in DMLIB (Recompile)   *
      *  CCB022A- COB Restructure - COB File Manager (rewrite)        *
      *  CCB022 - COB Restructure - COB File Manager                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRPROCES - Subroutine that checks if file passes complex     *
      *             condition or not.                                 *
      *  SRADDRMV - Adds or removes file members.                     *
      *  SRCHKSTS - Compares FMCOND against current status of module  *
      *             or switchable feature.                            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     FSDMMIDL1  IF   E           K DISK

     D PMode           S              4
     D PLFName         S             10
     D PMbrName        S             10
     D***PType           S              1                                                   MD024412
     D Ptype           S              6                                                     MD024412
     D PRtcd           S              7
     D POptn           S              7
     D PSard           S              6

     D WFomminTmp      S              1
     D WPrevFile       S             10
     D WPrevMbr        S             10
     D WAnd            S              1
     D WStat           S              1
     D WIgnore         S              1
     D WMode           S              4
     D WPrcsd          S              1
     D WMTotRow        S              4  0
     D WFTotRow        S              4  0
     D WSQLRtcd        S              4  0

     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A

     D PARM2           DS
     D  LENG                   1      4B 0

     D SDMMID        E DS                  EXTNAME(SDMMIDPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D***SCCOMJ*     E DS                  EXTNAME(SCCOMJK0)                                  CUP040
     D SCCOMJ        E DS                  EXTNAME(SCCOMJW0)                                  CUP040

      ** Main Processing

      ** Entry Parameters

     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2

      ** Recover before image

     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4000

      ** Recover after image

     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4000

      ** If file is SDMMIDPD and action is update.
      ** Global Updates - BEFORE/AFTER image
      ** TRGEVENT: '1'=INSERT, '2'=DELETE, '3'=UPDATE

     C                   IF        PFLNAME  = 'SDMMIDPD' and
     C                             TRGEVENT = '3'

      ** Check before and after image for FOMMIN change

     C                   EVAL      SDMMID = I#BIMG
     C                   EVAL      WFomminTmp = FOMMIN
     C                   EVAL      SDMMID = I#AIMG

      ** If FOMMIN has changed, check if it has records on SCCOMJK0
      ** then process complex conditions.

     C                   IF        FOMMIN <> WFomminTmp

      ** Read through the records of SCCOMJK0

     C/EXEC SQL
     C+ declare ACursor insensitive scroll cursor for
     C**select***from*SCCOMJK0*                                                               CUP040
     C+ select * from SCCOMJW0                                                                CUP040
     C+ where FMTYPE = 'F' and FMDEL = 'N'
     C+ order by FMTYPE, FMNAME, FMCSEQ, FMMBR, FMCCSQ
     C/END-EXEC

     C/EXEC SQL
     C+ open ACursor
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from ACursor into :SCCOMJ
     C/END-EXEC

     C                   EVAL      WSQLRtcd = SQLCODE

      ** When a record is read, check if at least one record in its
      ** complex condition sequence exists a Module-File-Member record.
      ** If none exists, do not process the record.

     C                   EXSR      CHKMOD

     C                   EVAL      WPrevFile = FMNAME
     C                   EVAL      WPrevMbr = FMMBR
     C                   EVAL      WIgnore = 'N'
     C                   EVAL      WPrcsd = 'N'
     C                   EVAL      FMCPLX = *BLANKS

     C                   DOW       WSQLRtcd = 0
     C                   IF        WMTotRow > 0
     C                   EXSR      SRPROCES
     C                   EVAL      WPrcsd = 'Y'
     C                   ENDIF

     C/EXEC SQL
     C+ fetch next from ACursor into :SCCOMJ
     C/END-EXEC

     C                   EVAL      WSQLRtcd = SQLCODE
     C                   EXSR      CHKMOD
     C                   ENDDO

      ** Process the last set of complex condition group
      ** if at least one satisfied the conditions above.

     C                   IF        WPrcsd = 'Y'
     C                   EVAL      FMNAME = *BLANKS
     C                   EVAL      FMMBR = *BLANKS
     C                   EXSR      SRPROCES
     C                   ENDIF

     C/EXEC SQL
     C+ close ACursor
     C/END-EXEC

     C                   ENDIF
     C                   ENDIF

      ** If file is SCSARDPD and action is update.
      ** TRGEVENT: '1'=INSERT, '2'=DELETE, '3'=UPDATE

     C**********         IF        PFLNAME  = 'SCSARDPD' AND                                MD055681
     C*********                    (TRGEVENT = '1' OR TRGEVENT = '2')                       MD055681
     C                   IF        (PFLNAME  = 'SCSRDCTD' OR                                MD055681
     C                             PFLNAME  = 'SCSRDBTD') AND                               MD055681
     C                             (TRGEVENT = '1' OR TRGEVENT = '2')                       MD055681
     C                             OR (PFLNAME  = 'SCSRDXTD' AND                            MD055681
     C                             TRGEVENT = '3')                                          MD055681

     C                   IF        TRGEVENT = '1'
     C                             or TRGEVENT = '3'                                        MD055681
     C                   EVAL      SCSARD = I#AIMG
     C                   ELSE
     C                   EVAL      SCSARD = I#BIMG
     C                   ENDIF

      ** Read through the records of SCCOMJK0

     C/EXEC SQL
     C+ declare BCursor insensitive scroll cursor for
     C**select***from*SCCOMJK0*                                                               CUP040
     C+ select * from SCCOMJW0                                                                CUP040
     C+ where FMTYPE = 'F' and FMDEL = 'N'
     C+ order by FMTYPE, FMNAME, FMCSEQ, FMMBR, FMCCSQ
     C/END-EXEC

     C/EXEC SQL
     C+ open BCursor
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from BCursor into :SCCOMJ
     C/END-EXEC

     C                   EVAL      WSQLRtcd = SQLCODE

      ** When a record is read, check if at least one record in its
      ** complex condition sequence exists a Module-File-Member record.
      ** If none exists, do not process the record.

     C                   EXSR      CHKFEAT

     C                   EVAL      WPrevFile = FMNAME
     C                   EVAL      WPrevMbr = FMMBR
     C                   EVAL      WIgnore = 'N'
     C                   EVAL      WPrcsd = 'N'
     C                   EVAL      FMCPLX = *BLANKS

     C                   DOW       WSQLRtcd = 0
     C                   IF        WFTotRow > 0
     C                   EXSR      SRPROCES
     C                   EVAL      WPrcsd = 'Y'
     C                   ENDIF

     C/EXEC SQL
     C+ fetch next from BCursor into :SCCOMJ
     C/END-EXEC

     C                   EVAL      WSQLRtcd = SQLCODE
     C                   EXSR      CHKFEAT
     C                   ENDDO

      ** Process the last set of complex condition group
      ** if at least one satisfied the conditions above.

     C                   IF        WPrcsd = 'Y'
     C                   EVAL      FMNAME = *BLANKS
     C                   EVAL      FMMBR = *BLANKS
     C                   EXSR      SRPROCES
     C                   ENDIF

     C/EXEC SQL
     C+ close BCursor
     C/END-EXEC

     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  SRPROCES - This subroutine processes the complex conditions  *
      *             and ADDS or REMOVES logical file members depending*
      *             if condition was satisfied or not.                *
      *  Called by : MAIN                                             *
      *  Calls     : SRADDRMV, SRCHKSTS                               *
      *                                                               *
      *****************************************************************
     C     SRPROCES      BEGSR

      ** Process Complex Conditions

     C                   IF        WPrcsd = 'Y' AND
     C                             (WPrevFile <> FMNAME OR
     C                             WPrevMbr <> FMMBR)
     C                   IF        WAnd = '1'
     C                   EVAL      WMode = '*RMV'
     C                   EXSR      SRADDRMV
     C                   ELSE
     C                   EVAL      WMode = '*ADD'
     C                   EXSR      SRADDRMV
     C                   ENDIF
     C                   EVAL      WIgnore = 'N'
     C                   EVAL      FMCPLX = *BLANKS
     C                   ENDIF

      ** If WIgnore = 'Y', condition was already met.
      ** No need to process further.

     C                   IF        WIgnore = 'N'

      ** Check the status of Switchable Feature or Module
      ** against FMCOND if it is satisfied.

     C                   EXSR      SRCHKSTS

     C                   IF        FMCPLX = *BLANKS
     C                   EVAL      WAnd = WStat
     C                   ENDIF
     C
     C                   IF        FMCPLX = '*AND'
     C                   IF        WAnd = '1' and WStat = '1'
     C                   EVAL      WAnd = '1'
     C                   ELSE
     C                   EVAL      WAnd = '0'
     C                   ENDIF
     C                   ENDIF
     C
     C                   IF        FMCPLX = '*OR'
     C                   IF        WAnd = '1'
     C                   EVAL      WIgnore = 'Y'
     C                   ELSE
     C                   EVAL      WAnd = WStat
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   EVAL      WPrevFile = FMNAME
     C                   EVAL      WPrevMbr = FMMBR
     C
     C                   ENDSR
      *****************************************************************
      *                                                               *
      ***SRADDRMV*-*This*subroutine*calls*SC001004*which*removes/adds**                     MD024412
      *  SRADDRMV - This subroutine calls SCC001007 which removes/adds*                     MD024412
      *             members of the passed by parameter LF             *
      *  Called By: SRPROCES                                          *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRADDRMV      BEGSR
     C**********         CALL(E)   'SC001004'                                               MD024412
     C**********         PARM      WMode         PMode                                      MD024412
     C**********         PARM      WPrevFile     PLFName                                    MD024412
     C**********         PARM      WPrevMbr      PMbrName                                   MD024412
     C**********         PARM      'F'           PType                                      MD024412
     C                   CALL      'SCC001007'                                              MD024412
     C                   PARM      WPrevFile     PLFName                                    MD024412
     C                   PARM      WPrevMbr      PMbrName                                   MD024412
     C                   PARM      WMode         PMode                                      MD024412
     C                   PARM      *BLANKS       PType                                      MD024412
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRCHKSTS - This subroutine checks if the condition is the    *
      *             same with the module's/feature's current status.  *
      *  Called by : MAIN                                             *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRCHKSTS      BEGSR

      ** If Switchable Feature is specified.

     C                   IF        FMFEAT <> *BLANKS
     C
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      FMFEAT        PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   EVAL      WStat = '0'
     C                   IF        PRtcd = *BLANKS AND FMCOND = '*ON'
     C                   EVAL      WStat = '1'
     C                   ENDIF
     C                   IF        PRtcd <> *BLANKS AND FMCOND = '*OFF'
     C                   EVAL      WStat = '1'
     C                   ENDIF

     C                   ENDIF

      ** If Module Name is specified.

     C                   IF        FMMOD <> *BLANKS

     C     FMMOD         CHAIN     SDMMIDL1

     C                   EVAL      WStat = '0'
     C                   IF        FOMMIN = 'Y' AND FMCOND = '*ON'
     C                   EVAL      WStat = '1'
     C                   ENDIF
     C                   IF        FOMMIN = 'N' AND FMCOND = '*OFF'
     C                   EVAL      WStat = '1'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  INZSR - Initial Subroutine.                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     KMODFM        KLIST
     C                   KFLD                    FOMMSN
     C                   KFLD                    FMNAME
     C                   KFLD                    FMMBR

     C     KFEATFM       KLIST
     C                   KFLD                    SARN
     C                   KFLD                    FMNAME
     C                   KFLD                    FMMBR

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  CHKMOD - Check if there is a Module-File-Member combination  *
      *           in the file's complex sequence.                     *
      *  Called By: Main                                              *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     CHKMOD        BEGSR

     C/EXEC SQL
     C+ declare MCursor insensitive scroll cursor for
     C**select***from*SCCOMJK0*                                                               CUP040
     C+ select * from SCCOMJW0                                                                CUP040
     C+ where FMMOD = :FOMMSN
     C+ and FMNAME = :FMNAME
     C+ and FMMBR = :FMMBR
     C+ and FMTYPE = 'F'
     C+ and FMDEL = 'N'
     C/END-EXEC

     C/EXEC SQL
     C+ open MCursor
     C/END-EXEC

     C/EXEC SQL
     C+ get diagnostics :WMTotRow = DB2_NUMBER_ROWS
     C/END-EXEC

     C/EXEC SQL
     C+ close MCursor
     C/END-EXEC
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  CHKFEAT - Check if there is a SFeat-File-Member combination  *
      *            in the file's complex sequence.                    *
      *  Called By: Main                                              *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     CHKFEAT       BEGSR

     C/EXEC SQL
     C+ declare FCursor insensitive scroll cursor for
     C**select***from*SCCOMJK0*                                                               CUP040
     C+ select * from SCCOMJW0                                                                CUP040
     C+ where FMFEAT = :SARN
     C+ and FMNAME = :FMNAME
     C+ and FMMBR = :FMMBR
     C+ and FMTYPE = 'F'
     C+ and FMDEL = 'N'
     C/END-EXEC

     C/EXEC SQL
     C+ open FCursor
     C/END-EXEC

     C/EXEC SQL
     C+ get diagnostics :WFTotRow = DB2_NUMBER_ROWS
     C/END-EXEC

     C/EXEC SQL
     C+ close FCursor
     C/END-EXEC

     C                   ENDSR
      *****************************************************************

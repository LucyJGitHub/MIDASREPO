     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SC Process CoB Optimisation Manager')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC001002 - Midas SC Process CoB Optimisation Manager         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD024412           Date 09May14               *
      *  Prev Amend No. AR1090366          Date 21Feb13               *
      *                 CCB022A *REWRITE   Date 06Aug12               *
      *                 CCB022  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024412 - Additional changes for COM processing             *
      *  AR1090366 - Deliverable data for SCCOMMTD and SCCOMXTD       *
      *            - were delivered, files are in DMLIB (Recompile)   *
      *  CCB022A- COB Restructure - COB File Manager (rewrite)        *
      *  CCB022 - COB Restructure - COB File Manager                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators.                                           *
      *                                                               *
      *       LR - End of Program                                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Midas modules information retrieval
     FSDMMIDL1  IF   E           K DISK
 
     D PMode           S              4
     D PLFName         S             10
     D PMbrName        S             10
     D***PType**         S              1                                                  MD024412
     D PType           S              6                                                    MD024412
     D PRtcd           S              7
     D POptn           S              7
     D PSard           S              6
 
     D WPrevFile       S             10
     D WPrevMbr        S             10
     D WAnd            S              1
     D WStat           S              1
     D WIgnore         S              1
     D WMode           S              4
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SCCOMJ        E DS                  EXTNAME(SCCOMJK0)
 
      ** Main Processing. Read through contents of SCCOMJK0.
      ** Only process FMTYPE = 'F' and FMDEL = 'N'
 
     C/EXEC SQL
     C+ declare ACursor insensitive scroll cursor for
     C+ select * from SCCOMJK0
     C+ where FMTYPE = 'F' and FMDEL = 'N'
     C+ order by FMTYPE, FMNAME, FMCSEQ, FMMBR, FMCCSQ
     C/END-EXEC
 
     C/EXEC SQL
     C+ open ACursor
     C/END-EXEC
 
     C/EXEC SQL
     C+ fetch next from ACursor into :SCCOMJ
     C/END-EXEC
 
     C                   EVAL      WPrevFile = FMNAME
     C                   EVAL      WPrevMbr = FMMBR
     C                   EVAL      WIgnore = 'N'
     C                   EVAL      FMCPLX = *BLANKS
 
     C                   DOW       SQLCODE = 0
 
      ** Process Complex Conditions
 
     C                   IF        WPrevFile <> FMNAME OR
     C                             WPrevMbr <> FMMBR
     C                   IF        WAnd = '1'
     C                   EVAL      WMode = '*RMV'
     C                   ELSE
     C                   EVAL      WMode = '*ADD'
     C                   ENDIF
     C                   EXSR      SRADDRMV
     C                   EVAL      WIgnore = 'N'
     C                   EVAL      FMCPLX = *BLANKS
     C                   ENDIF
 
      ** If WIgnore = 'Y', condition was already met.
      ** No need to process further.
 
     C                   IF        WIgnore = 'N'
 
      ** Check the status of Switchable Feature or Module
      ** against FMCOND if it is satisified.
 
     C                   EXSR      SRCHKSTS
 
     C                   IF        FMCPLX = *BLANKS
     C                   EVAL      WAnd = WStat
     C                   ENDIF
 
     C                   IF        FMCPLX = '*AND'
     C                   IF        WAnd = '1' AND WStat = '1'
     C                   EVAL      WAnd = '1'
     C                   ELSE
     C                   EVAL      WAnd = '0'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        FMCPLX = '*OR'
     C                   IF        WAnd = '1'
     C                   EVAL      WIgnore = 'Y'
     C                   ELSE
 
      ** Start all over
 
     C                   EVAL      WAnd = WStat
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WPrevFile = FMNAME
     C                   EVAL      WPrevMbr = FMMBR
 
     C/EXEC SQL
     C+ fetch next from ACursor into :SCCOMJ
     C/END-EXEC
 
     C                   ENDDO
 
      ** Evaluation for the last set of complex conditions.
 
     C                   IF        WAnd = '1'
     C                   EVAL      WMode = '*RMV'
     C                   ELSE
     C                   EVAL      WMode = '*ADD'
     C                   ENDIF
     C                   EXSR      SRADDRMV
 
     C/EXEC SQL
     C+ close ACursor
     C/END-EXEC
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  SRADDRMV - This subroutine calls SC001004 which removes/add  *
      *             members depending on the mode passed              *
      *  Called by : MAIN                                             *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRADDRMV      BEGSR
     C**********         CALL      'SC001004'
     C**********         PARM      WMode         PMode
     C**********         PARM      WPrevFile     PLFName
     C**********         PARM      WPrevMbr      PMbrName
     C**********         PARM      'F'           PType
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

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Backward-Looking Rate Rollover Input')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE001114 - Midas LE Backward-Looking Rate Rollover Input     *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Function: This program will select authorised rollover input *
      *            that changes the rate from forward-looking to      *
      *            backward-looking rate. The selected rollover       *
      *            transactions will be saved in an extract file such *
      *            that it will also be processed by the batch job.   *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CLE172  *CREATE    Date 01Oct20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE172 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************

     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** Data Sructure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short Data Structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data Structure for System Prefix
     D SDSTAT        E DS           256    EXTNAME(SDSTAT) DTAARA(SDSTAT)
     D  SYSID                  6      7

      ** Constants declaration
     D NO_ERROR        c                   const(0)
     D NO_RECORD       c                   const(100)

      ** Parameters for calling access programs
     D PRtCd           S              7A
     D POptn           S              7A

      ** Program Variables
     D WRUN            S              1A
     D Zone            S             10A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** MAIN PROCESSING

      ** Start commitment control
     C/exec SQL
     C+ set option COMMIT = *CHG
     C/end-exec

      ** Get Zone Name of the System ID
     C/exec SQL
     C+ select ZOZONE into :Zone
     C+ from GPZONEPD
     C+ where ZOMSYS = :SYSID
     C/end-exec

      ** Create temporary table for unauthorised rollover
     C/exec SQL
     C+ declare global temporary table LEWIPROLL
     C+ (TRANSREF char(6))
     C/end-exec

     C/exec SQL
     C+ insert into QTEMP/LEWIPROLL
     C+ select MSWTREF from T_MSWIP
     C+  where MSWAPI  = 'LERI' AND MSWZONE = :Zone
     C+    and MSWSTAT = 'TO_AUTHORISE'
     C/end-exec

     C                   IF        SQLCODE <> NO_ERROR and
     C                             SQLCODE <> NO_RECORD
     C                   EVAL      DBFILE = 'SQLERROR'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Insert to extract file the rollover details that changes loan
      ** from forward-looking to backward-looking rate OR
      ** rollover that still uses a backward-looking rate
     C/exec SQL
     C+ insert into LEROBLPD
     C+ select LNRF,  RLDT,
     C+        NBLRT, NRFRR, NCALM, NBADJ, NFLOR,
     C+        NLBDY, NLODY, NOPSH, NRRDP, NDBAV
     C+ from CLOANCL
     C+ where RLDT <> 0 and RLDT < :BJDNWD and NBLRT = 'Y'
     C+   and LNRF not in (select * from LEWIPROLL)
     C/end-exec

     C                   IF        SQLCODE <> NO_ERROR and
     C                             SQLCODE <> NO_RECORD
     C                   EVAL      DBFILE = 'SQLERROR'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 003
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If rollover input is not yet authorised and loan is using a
      ** backward-looking rate, insert to extract file the current
      ** backward-looking rate details
     C/exec SQL
     C+ insert into LEROBLPD
     C+ select LNRF, RLDT,
     C+        BLRT, RFRR, CALM, BADJ, FLOR,
     C+        LBDY, LODY, OPSH, RRDP, DBAV
     C+ from CLOANCL
     C+ where RLDT <> 0 and RLDT < :BJDNWD and BLRT = 'Y'
     C+   and LNRF in (select * from LEWIPROLL)
     C/end-exec

     C                   IF        SQLCODE <> NO_ERROR and
     C                             SQLCODE <> NO_RECORD
     C                   EVAL      DBFILE = 'SQLERROR'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 004
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Commit Changes
     C                   COMMIT

      ** End program
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Initialize Work fields
     C                   EVAL      DBPGM = 'LE000112'

      ** Retrieve System ID
     C     *LOCK         IN        SDSTAT
     C                   OUT       SDSTAT

      ** Get the Bank details via access program
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Update ARR Calculator Batch Job Status')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000118 - Midas SD Update ARR Calculator Batch Job Status   *
      *                                                               *
      *  Function:  This program updates the status of the ARR        *
      *             Calculator Batch Job (ARRCALC_zz)                 *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CSD103  *CREATE    Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
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

      ** Data Structure for System Prefix
     D SDSTAT        E DS           256    EXTNAME(SDSTAT) DTAARA(SDSTAT)
     D  SYSID                  6      7

      ** Data Structure for Current Time
     D CurrTime        DS
     D  WHrs                   1      2
     D  WColonC1               3      3
     D  WMin                   4      5
     D  WColonC2               6      6
     D  WSec                   7      8

      ** Constants declaration
     D NO_ERROR        c                   const(0)
     D NO_RECORD       c                   const(100)

      ** Entry Parameter
     D PStatus         S              1A

      ** Program Variables
     D WRUN            S              1A
     D RunDate         S              5S 0
     D NoOfRecs        S              3S 0
     D WStrDate        S              5S 0
     D WEndDate        S              5S 0
     D WEndTime        S              6A
     D WStrTime        S              6A
     D WTime           S              6A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** MAIN PROCESSING
     C     *ENTRY        PLIST
     C                   PARM                    PStatus

      ** Retrieve System ID
     C     *LOCK         IN        SDSTAT
     C                   OUT       SDSTAT

     C/exec sql
     C+ select BJRDNB into :RunDate
     C+   from SDBANKPD
     C/end-exec

     C                   EVAL      CurrTime = %char(%time():*HMS)
     C                   EVAL      WTime = WHrs + WMin + WSec

     C                   IF        PStatus = 'R'
     C                   EVAL      WStrDate = RunDate
     C                   EVAL      WStrTime = WTime
     C                   EVAL      WEndDate = *ZEROS
     C                   EVAL      WEndTime = *ZEROS
     C                   ELSE
     C                   EVAL      WEndDate = Rundate
     C                   EVAL      WEndTime = WTime
     C                   ENDIF

      ** Check if record exists on file already.
     C/exec SQL
     C+ select count(*) into :NoOfRecs
     C+ from SDCSTSTD
     C+ where SDZONE = :SYSID
     C/end-exec

      ** If there is no record, then write one
     C                   IF        NoOfRecs = *ZERO
     C/exec SQL
     C+ insert into SDCSTSTD
     C+ (
     C+   SDZONE, SDSTAT,
     C+   SDSTDT, SDSTTM,
     C+   SDENDT, SDENTM,
     C+   SDJOBN, SDJOBU, SDJNBR
     C+ )
     C+ values
     C+ (
     C+   :SYSID,     :PStatus,
     C+   :WStrDate,  :WStrTime,
     C+   :WEndDate,  :WEndTime,
     C+   :PSJobName, :PSUser, :PSJobNo
     C+ )
     C/end-exec

      ** Else, update the file depending on the status
      ** Update all fields if status is running
     C                   ELSEIF    NoOfRecs <> *ZERO and
     C                             PStatus = 'R'
     C/exec SQL
     C+ update SDCSTSTD
     C+ set SDSTAT = :PStatus,
     C+     SDSTDT = :WStrDate,  SDSTTM = :WStrTime,
     C+     SDENDT = :WEndDate,  SDENTM = :WEndTime,
     C+     SDJOBN = :PSJobName, SDJOBU = :PSUser, SDJNBR = :PSJobNo
     C+ where SDZONE = :SYSID
     C/end-exec

      ** Update only status, end date and time for other
      ** status (COMPLETED, FAILED)
     C                   ELSE
     C/exec SQL
     C+ update SDCSTSTD
     C+ set SDSTAT = :PStatus,
     C+     SDENDT = :WEndDate,
     C+     SDENTM = :WEndTime
     C+ where SDZONE = :SYSID
     C/end-exec
     C                   ENDIF

     C                   IF        SQLCODE <> NO_ERROR and
     C                             SQLCODE <> NO_RECORD
     C                   EVAL      DBFILE = 'SQLERROR'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF

      ** End program
     C                   EVAL      *INLR = *ON
     C                   RETURN

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

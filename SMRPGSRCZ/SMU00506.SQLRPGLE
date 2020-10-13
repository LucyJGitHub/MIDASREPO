     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Transfer JMS/MQ UserPwd to ValidationList')   *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00506 - Transfer JMS/MQ User Password to ValidationList   *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD056235  *CREATE  Date 12Oct20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056235 - Name Space Bindings for JMS has passwords is in   *
      *             clear text format                                 *
      *                                                               *
      *****************************************************************

      ** Program entry parameters
     D PZonePrefix     S              2A
     D PReturn         S              1A

      ** Program work variables
     D UserName        S             10A
     D Password        S            128A
     D WInterface      S             20A
     D WUser           S             50A
     D WUserDesc       S             50A
     D WUniq           S             75A
     D WTimestamp      S             26A   INZ('0001-01-01-00.00.00.000000')
     D WChangeType     S              1A
     D WLastChgUser    S             10A
     D WRun            S              1A

      ** PGM/SD000404 Parameters
     D PReturnCode     S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D PIDName         S            100A
     D PPass           S            128A
     D PDescr          S           1000A

     D/COPY GPCPYSRCG,PSDS

      ** MAIN PROCESSING

     C     *ENTRY        PLIST
     C                   PARM                    PZonePrefix
     C                   PARM                    PReturn

     C/exec SQL
     C+ declare USPW cursor for
     C+ select
     C+   SMUSER
     C+ , SMPASS
     C+ from SMUSPWTD
     C/end-exec

     C/exec SQL
     C+ open USPW
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from USPW
     C+ into
     C+   :Username
     C+ , :Password
     C/end-exec

     C                   DOW       SQLCOD <> 100

     C                   IF        SQLCOD <> 0 and SQLCOD <> 100
     C                   EVAL      PReturn = 'E'
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set program to fail if username or password is blanks
     C                   IF        Username = *BLANKS or
     C                             Password = *BLANKS
     C                   EVAL      PReturn = 'B'
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Update SDINTFVL validation list
     C                   IF        Username <> *BLANKS and
     C                             Password <> *BLANKS

     C                   EVAL      PValidList = 'SDINTFVL'
     C                   EVAL      PLibrary = PZonePrefix + 'DMLIB'
     C                   EVAL      PIDName = 'BANKFUSION_' + %trim(Username)
     C                   EVAL      PPass = Password

      ** Check if username already exists in the validation list
     C                   CALL      'SD000404'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      'F'           PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM                    PIDName
     C                   PARM                    PPass
     C                   PARM      *BLANKS       PDescr

      ** If not, add username and password in the validation list
     C                   IF        PReturnCode <> *BLANKS

     C                   EVAL      PIDName = 'BANKFUSION_' + %trim(Username)
     C                   EVAL      PPass = Password
     C                   CALL      'SD000404'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      'A'           PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM                    PIDName
     C                   PARM                    PPass
     C                   PARM      *BLANKS       PDescr

      ** Add record to SDFACXTD file
     C                   EXSR      SrInsFACX

     C                   ENDIF

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from USPW
     C+ into
     C+   :Username
     C+ , :Password
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close USPW
     C/end-exec

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInsFACX - Subroutine to write a record to SDFACXTD file     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      *****************************************************************
     C     SrInsFACX     BEGSR

     C                   EVAL      WInterface = 'BANKFUSION'
     C                   EVAL      WUser = Username
     C                   EVAL      WUniq = PIDName
     C                   EVAL      WUserDesc = *BLANKS
     C                   EVAL      WChangeType = 'I'
     C                   EVAL      WLastChgUser = PSUser

     C/exec SQL
     C+ insert into SDFACXTD
     C+ (
     C+   ININTF
     C+  ,INUSER
     C+  ,INUNIQ
     C+  ,INUSRD
     C+  ,INTMST
     C+  ,INTYLC
     C+  ,INLCUS
     C+ )
     C+ values
     C+ (
     C+   :WInterface
     C+  ,:WUser
     C+  ,:WUniq
     C+  ,:WUserDesc
     C+  ,:WTimeStamp
     C+  ,:WChangeType
     C+  ,:WLastChgUser
     C+ )
     C/end-exec

     C                   IF        SQLCOD <> 0
     C                   EVAL      PReturn = 'E'
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

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************

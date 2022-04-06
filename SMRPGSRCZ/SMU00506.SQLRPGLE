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
      *  Last Amend No. MD059760           Date 29Mar22               *
      *  Prev Amend No. MD058193           Date 07Sep20               *
      *                 MD056235  *CREATE  Date 03Jun20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059760 - BANKFUSION_wasadmin must be added in CTD,         *
      *             possibly record may already exist                 *
      *  MD058193 - Deliverable Data Split for SDFACCTD (re-work)     *
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
     D RecCount        S              5  0                                                  MD059760

      ** PGM/SD000404 Parameters
     D PReturnCode     S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D PIDName         S            100A
     D PPass           S            128A
     D PDescr          S           1000A
     D PDescrX         S             20A                                                    MD059760

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
     C+ , SMUDSC                                                                            MD059760
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
     C+ , :PDescrX                                                                          MD059760
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
     C**********         PARM      *BLANKS       PDescr                                     MD059760
     C                   PARM      PDescrX       PDescr                                     MD059760

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
     C+ , :PDescrX                                                                          MD059760
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
     C                   EVAL      WUserDesc = PDescrX                                      MD059760

     C                   eval      RecCount = 0                                             MD059760
     C/exec SQL                                                                             MD059760
     C+ select count(*) into :RecCount                                                      MD059760
     C+ from SDFUCXTD                                                                       MD059760
     C+ where INUNIQ = :WUniq                                                               MD059760
     C/end-exec                                                                             MD059760
      ** Key does not exist                                                                 MD059760
     C                   IF        RecCount = 0                                             MD059760
                                                                                            MD059760
     C/exec SQL
     C**insert*into SDFACXTD                                                                MD058193
     C+ insert into SDFUCXTD                                                                MD058193
     C+ (
     C+   ININTF
     C+  ,INUSER
     C+  ,INUNIQ
     C+  ,INUSRD
     C+  ,INTMST
     C+  ,INTYLC
     C+  ,INLCUS
     C+  ,INMODE                                                                            MD058193
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
     C+  ,'B'                                                                               MD058193
     C+ )
     C/end-exec
     C                   endif                                                              MD059760
     C                   eval      RecCount = 0                                             MD059760
     C/exec SQL                                                                             MD059760
     C+ select count(*) into :RecCount                                                      MD059760
     C+ from SDFUCCTD                                                                       MD059760
     C+ where INUNIQ = :WUniq                                                               MD059760
     C/end-exec                                                                             MD059760
      ** Key does not exist                                                                 MD059760
     C                   IF        RecCount = 0                                             MD059760
                                                                                            MD059760
     C/exec SQL                                                                             MD058193
     C**insert*into SDFUCBTD                                                       MD058193 MD059760
     C+ insert into SDFUCCTD                                                                MD059760
     C+ (                                                                                   MD058193
     C+   ININTF                                                                            MD058193
     C+  ,INUSER                                                                            MD058193
     C+  ,INUNIQ                                                                            MD058193
     C+  ,INUSRD                                                                            MD058193
     C+  ,INTMST                                                                            MD058193
     C+  ,INTYLC                                                                            MD058193
     C+  ,INLCUS                                                                            MD058193
     C+  ,INMODE                                                                            MD058193
     C+ )                                                                                   MD058193
     C+ values                                                                              MD058193
     C+ (                                                                                   MD058193
     C+   :WInterface                                                                       MD058193
     C+  ,:WUser                                                                            MD058193
     C+  ,:WUniq                                                                            MD058193
     C+  ,:WUserDesc                                                                        MD058193
     C+  ,:WTimeStamp                                                                       MD058193
     C+  ,:WChangeType                                                                      MD058193
     C+  ,:WLastChgUser                                                                     MD058193
     C+  ,'B'                                                                               MD058193
     C+ )                                                                                   MD058193
     C/end-exec                                                                             MD058193
     C                   endif                                                              MD059760

     C                   IF        SQLCOD <> 0
     C                             and RecCount = 0                                         MD059760
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

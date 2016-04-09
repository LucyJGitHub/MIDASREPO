     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Add new action file processing')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  UP000002 - Add new Action File processing                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CUP040             Date 06Mar13               *
      *  Prev Amend No. Ar863945 *CREATE   Date 11Nov11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP040 - New deliverable data methodology.                   *
      *  Ar863945 - New option to add Action File processing.         *
      *                                                               *
      *****************************************************************
     F***UPAFDVPD* UF   E             DISK                                                    CUP040
      *
     D*PLayer***       S              7                                                       CUP040
     D***CommandLen*   S             15  5 INZ(70)                                            CUP040
     D Recursive       S              1    INZ('N')
     D String          S           6000                                                       CUP040
      *
     D ACTF          E DS                  EXTNAME(UPACTFPD)                                  CUP040
     D AFFD          E DS                  EXTNAME(UPAFFDPD)                                  CUP040
      *
     D***AFCommand*      DS                                                                   CUP040
     D***Comamnd***             1     27    INZ('ACTIONFILE MODE(*ADD) FILE(')                CUP040
     D***AFile*****            28     37                                                      CUP040
     D***KeyFParm**            38     44    INZ(') KEYF(')                                    CUP040
     D***KFile*****            45     54                                                      CUP040
     D***LayerParm*            55     62    INZ(') LAYER(')                                   CUP040
     D***Layer*****            63     69                                                      CUP040
     D***CBracket*             70     70    INZ(')')                                          CUP040
      *
     C******ENTRY        PLIST                                                                CUP040
     C**********         PARM                    PLayer                                       CUP040
      *
      **Read*through*the*Action*File*checking*to*see*if*an*Insert*has*                        CUP040
      ***been*delivered*for*UPACTFPD,*but*only*for*the*correct*layer.*                        CUP040
     C**********         READ      UPAFDVPD                                                   CUP040
     C**********         DOU       %EOF                                                       CUP040
     C**********         IF        ATFILE = 'UPACTFPD' and                                    CUP040
     C**********                   ATACT = 'I' and                                            CUP040
     C**********                   %SUBST(ATDATA:21:7) = PLayer                               CUP040
     C/exec SQL                                                                               CUP040
     C+ declare AFDVcursor cursor for                                                         CUP040
     C+ select                                                                                CUP040
     C+   ATDATA                                                                              CUP040
     C+ from UPAFDVPD                                                                         CUP040
     C+ where                                                                                 CUP040
     C+     ATFILE = 'UPACTFPD'                                                               CUP040
     C+ and ATACT = 'I'                                                                       CUP040
     C/end-exec                                                                               CUP040
      *
     C/exec SQL                                                                               CUP040
     C+ open AFDVcursor                                                                       CUP040
     C/end-exec                                                                               CUP040
      *
     C                   EXSR      FetchRec1                                                  CUP040
      *
     C                   DOW       SQLCODE = 0                                                CUP040
      **********                                                                              CUP040
      **Break*down*the*data*for*the*ACTIONFILE*command.*                                      CUP040
     C**********         EVAL      AFile = %SUBST(ATDATA:1:10)                                CUP040
     C**********         EVAL      KFile = %SUBST(ATDATA:11:10)                               CUP040
     C**********         EVAL      Layer = PLayer                                             CUP040
      **********                                                                              CUP040
      **Run*the*ACTIONFILE*command.*                                                          CUP040
     C**********         EXSR      AddAF                                                      CUP040
      **Update*the*files*sp*that*they*are*ignored*for*later*processing.*                      CUP040
      **Select*only*records*for*the*correct*layer.*                                           CUP040
     C**********         IF        AALAYR = PLayer                                            CUP040
      * Attempt to delete records on UPACTFPD and UPAFFDPD first.
     C                   EXSR      DeleteRecs
      *
      * Add record to UPACTFPD.                                                               CUP040
     C                   EXSR      AddACTF                                                    CUP040
      * Add records to UPAFFDPD.                                                              CUP040
     C                   EXSR      AddAFFD                                                    CUP040
      *
     C                   EXSR      UpdateRecs
     C**********         ENDIF                                                                CUP040
      *
     C                   EXSR      FetchRec1                                                  CUP040
      *
     C**********         READ      UPAFDVPD                                                   CUP040
      *
     C                   ENDDO
      *
     C/exec SQL                                                                               CUP040
     C+ close AFDVcursor                                                                      CUP040
     C/end-exec                                                                               CUP040
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************                       CUP040
      *                                                               *                       CUP040
      * AddAFFD - Add records to UPAFFDPD                             *                       CUP040
      *                                                               *                       CUP040
      * Called by: *main                                              *                       CUP040
      *                                                               *                       CUP040
      * Calls:                                                        *                       CUP040
      *                                                               *                       CUP040
      *****************************************************************                       CUP040
      *
     C     AddAFFD       BEGSR                                                                CUP040
      *
      * Read through the Action File checking for inserts to UPAFFDPD.
     C/exec SQL                                                                               CUP040
     C+ declare AFDVcursor2 cursor for                                                        CUP040
     C+ select                                                                                CUP040
     C+   ATDATA                                                                              CUP040
     C+ from UPAFDVPD                                                                         CUP040
     C+ where                                                                                 CUP040
     C+     ATFILE = 'UPAFFDPD'                                                               CUP040
     C+ and ATACT = 'I'                                                                       CUP040
     C+ and substr(ATDATA,1,10) = :AABONF                                                     CUP040
     C/end-exec                                                                               CUP040
      *
     C/exec SQL                                                                               CUP040
     C+ open AFDVcursor2                                                                      CUP040
     C/end-exec                                                                               CUP040
      *
     C                   EXSR      FetchRec2                                                  CUP040
      *
     C                   DOW       SQLCODE = 0                                                CUP040
      * Add records to UPAFFDPD.                                                              CUP040
     C/exec SQL                                                                               CUP040
     C+ insert into UPAFFDPD                                                                  CUP040
     C+ (                                                                                     CUP040
     C+   AFFILE                                                                              CUP040
     C+ , AFFDNM                                                                              CUP040
     C+ , AFFDTX                                                                              CUP040
     C+ , AFFDTP                                                                              CUP040
     C+ , AFFDLN                                                                              CUP040
     C+ , AFFDPS                                                                              CUP040
     C+ , AFFDND                                                                              CUP040
     C+ , AFFDDP                                                                              CUP040
     C+ , AFKEYF                                                                              CUP040
     C+ , AFIGNC                                                                              CUP040
     C+ , AFDIFF                                                                              CUP040
     C+ , AFIGNU                                                                              CUP040
     C+ , AFCOID                                                                              CUP040
     C+ )                                                                                     CUP040
     C+ values                                                                                CUP040
     C+ (                                                                                     CUP040
     C+   :AFFILE                                                                             CUP040
     C+ , :AFFDNM                                                                             CUP040
     C+ , :AFFDTX                                                                             CUP040
     C+ , :AFFDTP                                                                             CUP040
     C+ , :AFFDLN                                                                             CUP040
     C+ , :AFFDPS                                                                             CUP040
     C+ , :AFFDND                                                                             CUP040
     C+ , :AFFDDP                                                                             CUP040
     C+ , :AFKEYF                                                                             CUP040
     C+ , :AFIGNC                                                                             CUP040
     C+ , :AFDIFF                                                                             CUP040
     C+ , :AFIGNU                                                                             CUP040
     C+ , :AFCOID                                                                             CUP040
     C+ )                                                                                     CUP040
     C/end-exec                                                                               CUP040
      *
     C                   EXSR      FetchRec2                                                  CUP040
      *
     C                   ENDDO                                                                CUP040
      *
     C/exec SQL                                                                               CUP040
     C+ close AFDVcursor2                                                                     CUP040
     C/end-exec                                                                               CUP040
      *
     C     AddAFFDE      ENDSR                                                                CUP040
      *
      /EJECT
      *****************************************************************                       CUP040
      *                                                               *                       CUP040
      * FetchRec1 - Fetch next record for UPACTFPD                    *                       CUP040
      *                                                               *                       CUP040
      * Called by: *main                                              *                       CUP040
      *                                                               *                       CUP040
      * Calls:                                                        *                       CUP040
      *                                                               *                       CUP040
      *****************************************************************                       CUP040
      *
     C     FetchRec1     BEGSR                                                                CUP040
      *
     C/exec SQL                                                                               CUP040
     C+ fetch next                                                                            CUP040
     C+ from AFDVcursor                                                                       CUP040
     C+ into                                                                                  CUP040
     C+   :String                                                                             CUP040
     C/end-exec                                                                               CUP040
      *
     C                   EVAL      ACTF = String                                              CUP040
      *
     C     FetchRec1E    ENDSR                                                                CUP040
      *
      /EJECT
      *****************************************************************                       CUP040
      *                                                               *                       CUP040
      * FetchRec2 - Fetch next record for UPAFFDPD                    *                       CUP040
      *                                                               *                       CUP040
      * Called by: *main                                              *                       CUP040
      *                                                               *                       CUP040
      * Calls:                                                        *                       CUP040
      *                                                               *                       CUP040
      *****************************************************************                       CUP040
      *
     C     FetchRec2     BEGSR                                                                CUP040
      *
     C/exec SQL                                                                               CUP040
     C+ fetch next                                                                            CUP040
     C+ from AFDVcursor2                                                                      CUP040
     C+ into                                                                                  CUP040
     C+   :String                                                                             CUP040
     C/end-exec                                                                               CUP040
      *
     C                   EVAL      AFFD = String                                              CUP040
      *
     C     FetchRec2E    ENDSR                                                                CUP040
      *
      /EJECT
      *****************************************************************
      *
     C     DeleteRecs    BEGSR
      *
     C/exec SQL
     C+ delete from UPACTFPD
     C**where*AABONF*=*:AFile*                                                                CUP040
     C+ where AABONF = :AABONF                                                                CUP040
     C/end-exec
      *
     C                   IF        SQLCODE <> 0 and
     C                             SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/exec SQL
     C+ delete from UPAFFDPD
     C**where*AFFILE*=*:AFile*                                                                CUP040
     C+ where AFFILE = :AABONF                                                                CUP040
     C/end-exec
      *
     C                   IF        SQLCODE <> 0 and
     C                             SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     DeleteRecsE   ENDSR
      *
      /EJECT
      *****************************************************************                       CUP040
      *                                                               *                       CUP040
      * AddACTF - Add record to UPACTFPD                              *                       CUP040
      *                                                               *                       CUP040
      * Called by: *main                                              *                       CUP040
      *                                                               *                       CUP040
      * Calls:                                                        *                       CUP040
      *                                                               *                       CUP040
      *****************************************************************                       CUP040
      *
     C     AddACTF       BEGSR                                                                CUP040
      *
     C/exec SQL                                                                               CUP040
     C+ insert into UPACTFPD                                                                  CUP040
     C+ (                                                                                     CUP040
     C+   AABONF                                                                              CUP040
     C+ , AAAFLF                                                                              CUP040
     C+ , AALAYR                                                                              CUP040
     C+ , AAORIF                                                                              CUP040
     C+ )                                                                                     CUP040
     C+ values                                                                                CUP040
     C+ (                                                                                     CUP040
     C+   :AABONF                                                                             CUP040
     C+ , :AAAFLF                                                                             CUP040
     C+ , :AALAYR                                                                             CUP040
     C+ , :AAORIF                                                                             CUP040
     C+ )                                                                                     CUP040
     C/end-exec                                                                               CUP040
      *
     C     AddACTFE      ENDSR                                                                CUP040
      *
      *****************************************************************                       CUP040
      **********                                                                              CUP040
     C*****AddAF         BEGSR                                                                CUP040
      **********                                                                              CUP040
      **Execute*ACTIONFILE*command.*                                                          CUP040
     C**********         CALL      'QCMDEXC'                                                  CUP040
     C**********         PARM                    AFCommand                                    CUP040
     C**********         PARM                    CommandLen                                   CUP040
      **********                                                                              CUP040
     C*****AddAFE        ENDSR                                                                CUP040
      *
      /EJECT
      *****************************************************************
      *
     C     UpdateRecs    BEGSR
      *
     C**********         EVAL      ATIGNA = 'Y'                                               CUP040
     C**********         UPDATE    UPAFCPD0                                                   CUP040
      *
     C/exec SQL                                                                               CUP040
     C+ update UPAFDVPD                                                                       CUP040
     C+ set ATIGNA = 'Y'                                                                      CUP040
     C+ where                                                                                 CUP040
     C+     ATFILE = 'UPACTFPD'                                                               CUP040
     C+ and ATACT = 'I'                                                                       CUP040
     C+ and substr(ATDATA, 1, 10) = :AABONF                                                   CUP040
     C/end-exec                                                                               CUP040
      *
     C/exec SQL
     C+ update UPAFDVPD
     C+ set ATIGNA = 'Y'
     C+ where ATFILE = 'UPAFFDPD' and ATACT = 'I'
     C**and*SUBSTR(ATDATA,*1,*10)*=*:AFile                                                    CUP040
     C+ and substr(ATDATA, 1, 10) = :AABONF                                                   CUP040
     C/end-exec
      *
     C/exec SQL
     C+ update UPAFDVPD
     C+ set ATIGNA = 'Y'
     C+ where ATFILE = 'UPAFFDPD' and ATACT = 'I'
     C**and*SUBSTR(ATDATA,*1,*10)*=*:AFile                                                    CUP040
     C+ and substr(ATDATA, 1, 10) = :AABONF                                                   CUP040
     C/end-exec
      *
     C                   IF        SQLCODE <> 0
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     UpdateRecsE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************

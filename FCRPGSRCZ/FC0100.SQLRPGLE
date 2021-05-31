     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Report distribution')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Report Control Facility Module
     F*                                                               *
     F*      FC0100 - REPORT DISTRIBUTION                             *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27089           Date 08Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CFC003             Date 22Mar06               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CFC002             Date 29Apr02               *
      *                 214962             Date 22May03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 142799             Date 27Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 106099             Date 26Feb96               *
     F*                 077317             Date 09OCT95               *
     F*                     087380           DATE 15MAY95             *
     F*                     S01382           DATE 17AUG92             *
     F*                     S01117           DATE 25MAR92             *
     F*                     S01269           DATE 25JUN91             *
     F*                     LN1157           DATE 15MAY91             *
     F*                     LN1007           DATE 26ONOV0             *
     F*                     LN0852           DATE 16OCT90             *
     F*                     LN0821           DATE 01OCT90             *
     F*                     LN0381           DATE 20JUN90             *
     F*                     LN0260           DATE 30MAY90             *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27089 - SCKOBJLCB failed                                  *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CFC003 - Use User department to print report on different    *
      *           printer when Report is System level                 *
      *           and Default output instruction ID is not blank      *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFC002 - Multiple Output Queues In Std Output Instructions   *
      *  214962 - RCFMONITOR is looping and filling up MOPERQ with    *
      *           messages relating to unfound spool files.  Update   *
      *           the status of unfound spool file to 'Y' (Abnormal)  *
      *           in PF/FCSFNOPD.                                     *
     F*  142799 - Add D6SFNO as one of the key fields for FCSFNOL0.   *
     F*         - Use the entity of the spool file number if exists   *
     F*           when distributing the reports whether branch or     *
     F*           company level.                                      *
     F*      106099 - Make sure last COB reports wil not be           *
     F*               skipped suring distribution/archiving.          *
     F*             - Applied fix 082081.                             *
     F*      077317 - Reset status field before reading next record(s)*   077317
     F*      087380 - Enlarge parameter for AOUSERR0                  *
     F*      S01382 - OPTICAL DISK DEVELOPMENT                        *
     F*               ADD SPOOL FILE NUMBER TO MAOWRKPD               *
     F*      S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD              *
     F*      S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO
     F*               MUSERDD
     F*      LN1157 - DURING INPUT CYCLE ACCESS CALL AORCFR0 TO       *
     F*               OBTAIN WAIT TIME.WAIT TIME DURING COB IS TO     *
     F*               BE FIXED AT 60 SECONDS.                         *
     F*      LN1007 - PRODUCE REPORTS IN COB IN SAME WAY AS FOR I/C   *
     F*      LN0852 - AMEND ERROR HANDLING.                           *
     F*      LN0821 - JOIN LOGICAL FILE FCSFNOL2 RENAMED TO FCSFNOJ0  *
     F*      LN0381 - changes made for Microfich Archiving            *
     F*      LN0260 - RESET FILE POINTER ON FCSFNOL2                  *
     F*                                                               *
     F*****************************************************************
      /EJECT
     F*****************************************************************
     F* OPERATION                                                     *
     F* ~~~~~~~~~                                                     *
     F*                                                               *
     F* TO TAKE REPORT REQUESTS FOR WHICH SPOOL FILES HAVE BEEN       *
     F* CREATED AND CHANGE THE ATTRIBUTES OF THE SPOOL FILES TO       *
     F* THOSE REQUIRED BY THE USER MAKING THE REQUEST.                *
     F*                                                               *
     F* ALSO SAVES DETAILS FOR ARCHIVING VIA:                         *
     F*                                                               *
     F*      CALLS FCC0402 TO COPY DETAILS TO MAAWRKPD                *
     F*      WRITES A RECORD TO MAMWRKPD                              *
     F*      WRITES A RECORD TO MAOWRKPD                              *
     F*                                                               *
     F*      INDICATORS:                                              *
     F*********************11   END OF PRIME INPUT FILE FCSFNOL2      *   LN0821
     F*                    11   END OF PRIME INPUT FILE FCSFNOJ0      *   LN0821
     F*                    12   CHAIN FAIL ARCHVIE CONTENTS DAILY     *
     F*                    13   CHAIN FAIL TO FCSFNOL0 (DBERR)        *
     F*                    30   LOKUP INDICATOR                       *
      *                    50   Report Suffix record not found        *   LN0381
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*                  SUMMARY  OF  SUBROUTINES                     *
     F*                 **************************                    *
     F*     SPLFIL  -  Access Spool File Processing.                  *
     F*     ARCHIV  -  Archive Processing.                            *
     F*     ARMCRO  -  Archive to microfiche Processing.              *
     F*     AROPTD  -  Archive to Optical Disk Processing.            *
     F*     DSTRBT  -  Distribute Processing.                         *
     F*     SNGBCH  -  Single Branch Report Processing.               *
     F*     BNKWDE  -  Bankwide Report Processing.                    *
     F*     BRCHLV  -  Branch Level Report Processing.                *
     F*     COMLVL  -  Company Level Report Processing.               *
     F*     DSTRBL  -  Distribution List Processing.                  *
     F*     USERID  -  User ID Processing.                            *
     F*     STNDIN  -  Standard Instructions Processing.              *
     F*     DSTCOB  -  Distribute to Company/Branch Processing.       *
     F*     SPLFNO  -  Update Spool File Numbers Processing.          *
     F*     *PSSR   -  Database Error Handling : Terminates program   *
     F*****************************************************************
     F*
     F*FCSFNOL2IF*E********   K        DISK                               LN0821
     FFCSFNOJ0  IF   E           K DISK                                         LN0821
     FMAARCDL2  IF   E           K DISK
     FFCSFNOL0  UF   E           K DISK
     F                                     COMMIT
     FMAMWRKPD  O    E           K DISK
     F                                     COMMIT
     FMAOWRKPD  O    E             DISK
     F                                     COMMIT
     FMAEXPTPD  O    E             DISK                                         LN0381
     F                                     COMMIT                               LN0381
     F*FCRSFXL0* IF   E           K DISK                                         LN0381     MD055265
     FMAFOQPPD  IF   E             DISK
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D FNAM            S              1    DIM(10)
      /EJECT
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      * DATA STRUCTURE FOR DATABASE ERROR.
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                   087380
     D DSSDY         E DS                  EXTNAME(DSSDY)                       087380
      * 800 LONG DATA STRUCTURE FOR DATABASE ERROR.                       087380
      *
     D D@RCF         E DS                  EXTNAME(SDRCFPD)
      * LF/SDRCFL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D P@ARCH        E DS                  EXTNAME(MAARCHPD)
      * LF/MAARCHL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D P@SOUT        E DS                  EXTNAME(FCSOUTPD)
      * LF/FCSOUTL1 ACCESS PROGRAM REOCRD FORMAT DATA STRUCTURE
      *
     D P@BRCH        E DS                  EXTNAME(SDBRCHPD)
      * LF/SDBRCHL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D P@USER        E DS                  EXTNAME(MUSER)
      * LF/MUSER ACCESS PROGRAM REOCRD FORMAT DATA STRUCTURE
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  S0LCD        E                     EXTFLD(LCD)
      * Data structure for switchable feature                                                 CFC002
      *                                                                                       CFC002
     D RPSSFN          DS
      *
      ** DATA STRUCTURE TO DEFINE KEY FIELDS FOR LF/FCSFNOL0 DBERR
      *
     D**********                              1  10 D6RNAM                LN0852
     D  D5RNAM                 1     10                                         LN0852
     D  D6RQSQ                11     15
     D  D6RSFX                16     25
     D  D6XETY                26     28
      *
      **                          KEY FIELDS FOR LF/FCARCDL0 DBERR
      *
     D  RPSSUF                 1     17
     D FCRSFX        E DS                  EXTNAME(FCRSFJW0)                                MD055265
      /EJECT
     C**
     C*
     C**PARAMETER*PASSED*FROM*FCC0401*-*PHASE*OF*DAY.******************   LN1007
     C*
     C************ENTRY    PLIST                                          LN1007
     C***********          PARM           PHASDY  1                       LN1007
     C*                                                                   LN1157
     C** PARAMETER PASSED FROM FCC0401 - PHASE OF DAY.                    LN1157
     C*                                                                   LN1157
     C     *ENTRY        PLIST                                                                 LN115
     C                   PARM                    PHASDY            1                           LN115
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
      ** KEY LIST FOR ARCHIVE DETAILS LF/FCARCDL0
     C*
     C     ARCDK         KLIST
     C**********           KFLD           D6RNAM                          LN0852
     C                   KFLD                    D5RNAM                                        LN085
     C                   KFLD                    D6RQSQ
     C                   KFLD                    D6RSFX
     C*
      ** KEY LIST SPOOL FILE NUMBERS LF/FCSFNOL0
     C*
     C     SFNOK         KLIST
     C                   KFLD                    D6RQSQ
     C                   KFLD                    D6RSFX
     C                   KFLD                    D6XETY
     C                   KFLD                    D6SFNO                                        14279
      *                                                                   LN0381
      ** Key List for the Report Suffix file LF/FCRSFXL0                  LN0381
      *                                                                   LN0381
     C     RSFXK         KLIST                                                                 LN038
     C                   KFLD                    EBRNAM                                        LN038
     C                   KFLD                    EBRSFX                                        LN038
      /SPACE 3
     C*
     C                   MOVEL     'FC0100'      DBPGM
     C*
     C** Setup data queue parameters
     C*
     C                   MOVEL     'FCDTAQ'      DTAQ             10
     C                   MOVEL     '*LIBL'       LIB              10
     C                   Z-ADD     1             LENA              5 0
      *                                                                                       CFC003
      ** CFC003 - Check whether Feature is active                                             CFC003
      *                                                                                       CFC003
     C                   MOVE      'N'           CFC003            1
     C                   CALL      'AOSARDR0'                             99
     C                   PARM      '       '     PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CFC003'      PSARD             6
      *                                                                                       CFC003
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFC003
     C                   ENDIF
     C*
      ** ON ENTRY TO PROGRAM, CHECK IF OUTSTANDING REPORTS TO DISTRIBUTE
     C*
     C                   EXSR      SPLFIL
     C*
      ***IF*PROGRAM*CALLED*DURING*INPUT*CYCLE,*ACCESS*RCF*ICD*FOR*WAIT*TIMLN1007
     C*
     C***********PHASDY    IFEQ 'I'                                       LN1007
     C*                                                                   LN1157
     C** DURING INPUT CYCLE ONLY CALL AORCFR0 FOR WAIT TIME               LN1157
     C*                                                                   LN1157
     C     PHASDY        IFEQ      'I'                                                         LN115
     C*                                                                   LN1007
      * ACCESS RCF ICD FOR WAIT TIME                                      LN1007
     C*                                                                   LN1007
     C                   CALL      'AORCFR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*FIRST'      P@APOP            7              I:Option
     C     D@RCF         PARM      D@RCF         DSFDY                            O:Rec format
     C*
     C**  IF RCF ICD NOT FOUND DATABASE ERROR.
     C*
     C     P@APRC        IFNE      *BLANK
     C                   MOVEL     'SDRCFL1'     DBFILE                         *************
     C                   MOVEL     '*FIRST'      DBKEY                          *           *
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   EXSR      *PSSR                                        *           *
     C                   END                                                    *************
      *                                                                                       CFC002
      ** Access switchable feature details to chk if CFC002 is on                             CFC002
      *                                                                                       CFC002
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CFC002'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CFC002
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFC002            1
     C                   ELSE
     C                   MOVE      'N'           CFC002
     C                   ENDIF
     C*
     C** Setup data queue parameters
     C*
     C                   Z-ADD     D0DWTI        WAIT              5 0
     C                   END                                                                   LN115
     C*                                                                   LN1157
     C** DURING CLOSE OF BUSINESS DISTRIBUTION IS TO TAKE PLACE AT        LN1157
     C** A FIXED TIME OF EVERY 60 SECONDS.                                LN1157
     C*                                                                   LN1157
     C     PHASDY        IFEQ      'C'                                                         LN115
     C                   Z-ADD     60            WAIT                                          LN115
     C                   END                                                                   LN115
     C*                                                                   LN1157
     C** Receive data queue
     C*
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DTAQ
     C                   PARM                    LIB
     C                   PARM                    LENA
     C                   PARM                    DATA              1
     C                   PARM                    WAIT
     C*
      ** PERFORM DISTRIBUTION UNTIL DATA QUEUE ENTRY IS A REQUEST TO
      ** TERMINATE PROGRAM (ENTRY 'T')
     C*
     C     DATA          DOWNE     'T'
     C*
     C                   EXSR      SPLFIL
     C*
     C** Receive data queue
     C*
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DTAQ
     C                   PARM                    LIB
     C                   PARM                    LENA
     C                   PARM                    DATA
     C                   PARM                    WAIT
     C*
      ** ENDDO
     C*
     C                   END
     C*                                                                   106099
     C** Execute SR/SPLFIL one more time after receiving the termination  106099
     C** request to ensure that all the reports will be processed         106099
     C*                                                                   106099
     C                   EXSR      SPLFIL                                                      10609
     C*                                                                   LN1007
      *  END OF REPORT DISTRIBUTION PROCESSING                            LN1007
     C*
      ***END*OF*INPUT*CYCLE*PROCESSING*********************************   LN1007
     C***********                                                         LN1007
     C***********          END                                            LN1007
     C***********                                                         LN1007
      ***IF*CLOSE*OF*BUSINESS,*WAIT*FOR*DATA*SENT*TO*DATA*QUEUE********   LN1007
     C***********                                                         LN1007
     C***********PHASDY    IFEQ 'C'                                       LN1007
     C***********                                                         LN1007
     C***********          Z-SUB1         WAIT                            LN1007
     C***********                                                         LN1007
     C***Receive*data*queue********************************************   LN1007
     C***********                                                         LN1007
     C***********          CALL 'QRCVDTAQ'                                LN1007
     C***********          PARM           DTAQ                            LN1007
     C***********          PARM           LIB                             LN1007
     C***********          PARM           LENA                            LN1007
     C***********          PARM           DATA                            LN1007
     C***********          PARM           WAIT                            LN1007
     C***********                                                         LN1007
      ***PERFORM*DISTRIBUTION*UNTIL*DATA*QUEUE*ENTRY*IS*A*REQUEST*TO***   LN1007
      ***TERMINATE*PROGRAM*(ENTRY 'T')*********************************   LN1007
     C***********                                                         LN1007
     C***********DATA      DOWNE'T'                                       LN1007
     C***********                                                         LN1007
     C***********          EXSR SPLFIL                                    LN1007
     C***********          Z-SUB1         WAIT                            LN1007
     C***********                                                         LN1007
     C***Receive*data*queue********************************************   LN1007
     C***********                                                         LN1007
     C***********          CALL 'QRCVDTAQ'                                LN1007
     C***********          PARM           DTAQ                            LN1007
     C***********          PARM           LIB                             LN1007
     C***********          PARM           LENA                            LN1007
     C***********          PARM           DATA                            LN1007
     C***********          PARM           WAIT                            LN1007
     C***********                                                         LN1007
      ***ENDDO*********************************************************   LN1007
     C***********                                                         LN1007
     C***********          END                                            LN1007
     C***********                                                         LN1007
      ***END*OF*CLOSE*OF*BUSINESS*PROCESSING***************************   LN1007
     C***********                                                         LN1007
     C***********          END                                            LN1007
     C***********                                                         LN1007
      *                                                                   LN1007
      ** TERMINATE PROGRAM
     C*
     C                   SETON                                        LR
     C*
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM ACCESS SPOOL FILE PROCESSING.          *
     C*                                                               *
     C* CALLED FROM :                                                 *
     C* CALLS       :  ARCHIV - Archive processing.                   *
     C*                DSTRBT - Distribute processing.                *
     C*                SPLFNO - Update spool file numbers processing. *
     C*                                                               *
     C* FIELDS      :  D5ARMF - Archived on microfiche                *
     C*                D5AROD - Archived on optical disk.             *
     C*****************************************************************
     C*
     C     SPLFIL        BEGSR
     C* CLEAR STATUS FIELD                                                LN0852
     C                   MOVEL     *BLANK        STATUS                                        LN085
     C*                                                                   LN0260
     C***RESET*FILE*POINTER*ON*FCSFNOL2******                       LN0260LN0821
     C** RESET FILE POINTER ON FCSFNOJ0                                   LN0821
     C*                                                                   LN0260
     C***********'00000'***SETLLFCSFNOL2                            LN0260LN0821
     C     '00000'       SETLL     FCSFNOJ0                                                    LN082
     C*
     C***READ*LF/FCSFNOL2*(PRINT*FILES*NOT*DISTRIBUTED)*FOR*NEXT*RECORD.  LN0821
     C** READ LF/FCSFNOJ0 (PRINT FILES NOT DISTRIBUTED) FOR NEXT RECORD.  LN0821
     C*
     C*********************READ FCSFNOL2                 11               LN0821
     C                   READ      FCSFNOJ0                               11                   LN082
     C*
     C***DOWHILE*RECORD*EXIST*ON*LF/FCSFNOL2*(PRINT*FILES*NOT*DISTRIBUTED)LN0821
     C** DOWHILE RECORD EXIST ON LF/FCSFNOJ0 (PRINT FILES NOT DISTRIBUTED)LN0821
     C*
     C     *IN11         DOWEQ     '0'
     C*
     C                   MOVE      D6RSFX        FILNAM           10
     C*
      ** IF REPORT IS TO BE ARCHIVED, CHECK IF THIS PRINT TO BE SAVED
     C*
     C     D5ARMF        IFEQ      'Y'
     C     D5AROD        OREQ      'Y'
     C                   EXSR      ARCHIV
     C                   END
     C*
      ** DISTRIBUTE PRINT
     C*
     C     STATUS        IFNE      'Y'                                                         LN085
     C                   EXSR      DSTRBT
     C                   EXSR      SPLFNO
     C                   ENDIF
     C     STATUS        IFEQ      'Y'                                                         LN085
     C                   ROLBK                                                                 LN085
     C**********           ELSE                                                        LN0852 214962
     C*
      ** UPDATE STATUS OF PRINT TO DISTRIBUTED(/PRINTED)
     C*
     C                   EXSR      SPLFNO
     C                   END                                                                   LN085
     C**********           END                                                         LN0852 214962
     C*
      ** READ NEXT SPOOL FILE TO BE DISTRIBUTED
     C*
     C*********************READ FCSFNOL2                 11               LN0821
     C                   READ      FCSFNOJ0                               11                   LN082
     C*                                                                   077317
     C* RESET STATUS FIELD BEFORE READING NEXT RECOD(S)                   077317
     C                   MOVEL     *BLANK        STATUS                                        07731
     C*
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM ARCHIVE PROCESSING.                    *
     C*                                                               *
     C* CALLED FROM :  SPLFIL - Spool file processing.                *
     C* CALLS       :  ARMCRO - Archive to microfiche processing.     *
     C*                AROPTD - Archive to optical disk processing.   *
     C*                                                               *
     C* FIELDS      :  D6RNAM - Report name.                          *
     C*                D6RQSQ - Sequence number.                      *
     C*                D6RSFX - Print suffix.                         *
     C*                A8DSNB - Branch code.                          *
     C*                EAMEDM - Medium.                               *
     C*****************************************************************
     C*
     C     ARCHIV        BEGSR
     C*
     C** ACCESS LF/MAARCDL2 FOR THIS REPORT/SEQUENCE/PRINT SUFFIX.
     C**            (ARCHIVE CONTENTS DAILY)
     C*
     C     ARCDK         CHAIN     MAARCDL2                           12
     C*
     C** DOWHILE RECORDS EXSITS ON LF/MAARCDL2 FOR THE REPORT/SEQ/SFX
     C*
     C     *IN12         DOWEQ     '0'
     C*
     C** CALL 'AOARCHR0' TO ACCESS LF/MAARCHL1 (ARCHIVE ID DETAILS)
     C** FOR MEDIUM
     C*
     C                   CALL      'AOARCHR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM                    EBARID                           I:Archive id
     C     P@ARCH        PARM      P@ARCH        DSFDY                            O:Rec format
     C*
     C** IF PROGRAM ENDS IN ERROR DATABASE ERROR.
     C*
     C     P@APRC        IFNE      *BLANK
     C                   MOVEL     'MAARCHL1'    DBFILE                         *************
     C                   MOVEL     EBARID        DBKEY                          *           *
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   EXSR      *PSSR                                        *           *
     C                   END                                                    *************
     C*
     C** IF MEDIUM IS MICROFICHE, ACCESS MICROFICHE FILES
     C*
     C     EAMEDM        IFEQ      'M'
     C     EAMEDM        OREQ      'B'                                                         S0138
     C                   EXSR      ARMCRO
     C                   END
     C*
     C** IF MEDIUM IS OPTICAL DISK, ACCESS OPTICAL DISK FILES
     C*
     C     EAMEDM        IFEQ      'O'
     C     EAMEDM        OREQ      'B'                                                         S0138
     C                   EXSR      AROPTD
     C                   END
     C*
     C** ACCESS NEXT LF/MAARCDL2 RECORD.
     C*
     C     ARCDK         READE     MAARCDL2                               12
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM ARCHIVE TO MICROFICHE PROCESSING.      *
     C*                                                               *
     C* CALLED FROM :  ARCHIV - Archive processing.                   *
     C* CALLS       :  NONE                                           *
     C*                                                               *
     C* FIELDS      :  EBRNAM - Report name.                          *
     C*                EBRSFX - Print suffix.                         *
     C*                D5JBNM - Job name.                             *
     C*                D5JUSR - User name.                            *
     C*                D5JBNB - Job number.                           *
     C*                D6SFNO - Spool file number.                    *
     C*                EDFRCD - First record number.                  *
     C*                EDLRCD - last record number.                   *
     C*****************************************************************
     C*
     C     ARMCRO        BEGSR
     C*
     C** CALL FCC0402 TO WRITE SPOOL FILES TO THE ARCHIVE WORK FILE
     C** AND RETURN THE FIRST/LAST RECORD NUMBERS FIELD IN THIS FILE.
     C*
     C                   CALL      'FCC0402'
     C                   PARM                    FILNAM
     C                   PARM                    D5JBNM
     C                   PARM                    D5JUSR
     C                   PARM                    D5JBNB
     C                   PARM                    D6SFNO
     C                   PARM      *BLANK        FILNFF            1
     C                   PARM      *ZEROS        EDFRCD
     C                   PARM      *ZEROS        EDLRCD
     C*
      ***PRINTER*FILE*DETAILS******                                       LN0381
      ****************                                                    LN0381
     C****************     PARM           EFFMTP                          LN0381
     C****************     PARM           EFPLEN                          LN0381
     C****************     PARM           EFLPI                           LN0381
     C*
     C* IF ERROR FLAG RETURNS AS BLANK (NO ERROR) SET STATUS TO 'D',      LN0852
     C* ELSE SET STATUS TO VALUE OF FLAG: 'P' - PRINTED                   LN0852
     C*                                OR 'Y' - ABNORMAL.                 LN0852
     C     FILNFF        IFEQ      *BLANK                                                      LN085
     C                   MOVEL     'D'           STATUS                                        LN085
     C                   ELSE                                                                  LN085
     C                   MOVEL     FILNFF        STATUS                                        LN085
     C                   END                                                                   LN085
     C*                                                                   LN0852
     C***IF*FILE*TRANSFER*SUCESSFUL*(ERROR*FLAG*NOT*'Y')***               LN0852
     C** IF FILE TRANSFER SUCCESSFUL (ERROR FLAG IS BLANK)                LN0852
     C** OUTPUT RECORD TO PF/MAMWRKPD TO UPDATE MICROFICHE INDEX.
     C*
     C********** FILNFF    IFNE 'Y'                                       LN0852
     C     FILNFF        IFEQ      *BLANK                                                      LN085
     C                   MOVE      EBARID        EDARID
     C                   MOVE      EBRNAM        EDRNAM
     C                   MOVE      EBRQSQ        EDRQSQ
     C                   MOVE      EBRSFX        EDRSFX
     C                   WRITE     MAMWRKD0
     C                   END                                                                   LN085
      *                                                                   LN0381
      ***ELSE*-*WRITE*A*RECORD*TO*THE*ARCHIVE*EXCEPTIONS*FILE***    LN0381LN0852
      ** IF FLAG IS 'P' - WRITE A RECORD TO THE ARCHIVE EXCEPTIONS FILE   LN0852
      *                                                                   LN0381
     C**********           ELSE                                     LN0381LN0852
     C     FILNFF        IFEQ      'P'                                                         LN085
      * Get REPORT descr.                                                 LN0381
     C                   MOVE      *BLANKS       DYPFTX                                        LN038
     C********** RSFXK     CHAINFCRSFXL0             50                              LN0381 BUG27089
     C*****RSFXK         CHAIN(N)  FCRSFXL0                           50                    MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRSFX                                                                        MD055265
     C+ from FCRSFJW0                                                                       MD055265
     C+ where DYRNAM = :EBRNAM and DYRSFX = :EBRSFX                                         MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                         50                  MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                          50                  MD055265
     C                   ENDIF                                                              MD055265
                                                                                            MD055265
     C                   MOVE      DYPFTX        EXPFTX                                        LN038
      * Write Exception rec.                                              LN0381
     C                   MOVE      EBARID        EXARID                                        LN038
     C                   MOVE      EBRNAM        EXRNAM                                        LN038
     C                   MOVE      EBRSFX        EXRSFX                                        LN038
     C                   WRITE     MAEXPTD0                                                    LN038
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM ARCHIVE TO OPTICAL DISK PROCESSING.    *
     C*                                                               *
     C* CALLED FROM :  ARCHIV - Archive processing.                   *
     C* CALLS       :  NONE                                           *
     C*                                                               *
     C* FIELDS      :  EBRNAM - Report name.                          *
     C*                EBRSFX - Print suffix.                         *
     C*                D5JBNM - Job name.                             *
     C*                D5JUSR - User name.                            *
     C*                D5JBNB - Job number.                           *
     C*                D6SFNO - Spool file number.                    *
     C*                EDFRCD - First record number.                  *
     C*                EDLRCD - last record number.                   *
     C*****************************************************************
     C*
     C     AROPTD        BEGSR
      *                                                                   LN0381
      ** ACCESS THE PRINTER FILE DETAILS                                  LN0381
      *                                                                   LN0381
     C                   CALL      'MAC0010'                                                   LN038
     C                   PARM                    FILNAM                                        LN038
     C                   PARM                    D5JBNB                                        LN038
     C                   PARM                    D5JUSR                                        LN038
     C                   PARM                    D5JBNM                                        LN038
     C                   PARM                    D6SFNO                                        LN038
     C                   PARM      *BLANKS       @@FMTP           10                           LN038
     C                   PARM      *BLANKS       @@PLEN            3                           LN038
     C                   PARM      *BLANKS       @@LPI             1                           LN038
     C                   PARM      *BLANK        FILNFF                                        LN038
      *                                                                   LN0381
     C********** FILNFF    IFNE 'Y'                                 LN0381LN0852
     C     FILNFF        IFEQ      *BLANK                                                      LN085
      *                                                                   LN0381
     C                   MOVE      @@FMTP        EFFMTP                                        LN038
     C                   MOVE      @@PLEN        EFPLEN                                        LN038
     C                   MOVE      @@LPI         EFLPI                                         LN038
     C*
     C** CALL FCC0402 TO WRITE SPOOL FILES TO THE ARCHIVE WORK FILE
     C** AND RETURN THE FIRST/LAST RECORD NUMBERS AND SPOOL FILE
     C** ATTRIBUTES
     C*
     C                   CALL      'FCC0402'
     C                   PARM                    FILNAM
     C                   PARM                    D5JBNM
     C                   PARM                    D5JUSR
     C                   PARM                    D5JBNB
     C                   PARM                    D6SFNO
     C                   PARM      *BLANK        FILNFF
     C                   PARM      *ZEROS        EFFRCD
     C                   PARM      *ZEROS        EFLRCD
     C*
      ** PRINTER FILE DETAILS
     C*
     C****************     PARM           EFFMTP                          LN0381
     C****************     PARM           EFPLEN                          LN0381
     C****************     PARM           EFLPI                           LN0381
      *                                                                   LN0381
     C                   END                                                                   LN038
     C*
     C* IF ERROR FLAG RETURNS AS BLANK (NO ERROR) SET STATUS TO 'D',      LN0852
     C* ELSE SET STATUS TO VALUE OF FLAG: 'P' - PRINTED                   LN0852
     C*                                OR 'Y' - ABNORMAL.                 LN0852
     C     FILNFF        IFEQ      *BLANK                                                      LN085
     C                   MOVEL     'D'           STATUS                                        LN085
     C                   ELSE                                                                  LN085
     C                   MOVEL     FILNFF        STATUS                                        LN085
     C                   END                                                                   LN085
     C*                                                                   LN0852
     C** OUTPUT RECORD TO PF/MAOWRKPD TO UPDATE OPTICAL DISK INDEX.
     C*
     C********** FILNFF    IFNE 'Y'                                       LN0852
     C     FILNFF        IFEQ      *BLANK                                                      LN085
     C*
      ** REPORT DETAILS
     C*
     C                   MOVE      EBARID        EFARID
     C                   MOVE      EBRNAM        EFRNAM
     C                   MOVE      EBRQSQ        EFRQSQ
     C                   MOVE      EBRSFX        EFRSFX
     C                   MOVE      D6SFNO        EFSPFN                                        S0138
     C*
     C                   WRITE     MAOWRKD0
     C                   END                                                                   LN085
      *                                                                   LN0381
      ***ELSE*-*WRITE*A*RECORD*TO*THE*ARCHIVE*EXCEPTIONS*FILE***    LN0381LN0852
      ** IF FLAG IS 'P' - WRITE A RECORD TO THE ARCHIVE EXCEPTIONS FILE   LN0852
      *                                                                   LN0381
     C**********           ELSE                                     LN0381LN0852
     C     FILNFF        IFEQ      'P'                                                         LN085
      * Get REPORT descr.                                                 LN0381
     C                   MOVE      *BLANKS       DYPFTX                                        LN038
     C********** RSFXK     CHAINFCRSFXL0             50                              LN0381 BUG27089
     C*****RSFXK         CHAIN(N)  FCRSFXL0                           50                    MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRSFX                                                                        MD055265
     C+ from FCRSFJW0                                                                       MD055265
     C+ where DYRNAM = :EBRNAM and DYRSFX = :EBRSFX                                         MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                         50                  MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                          50                  MD055265
     C                   ENDIF                                                              MD055265
                                                                                            MD055265
     C                   MOVE      DYPFTX        EXPFTX                                        LN038
      * Write Exception rec.                                              LN0381
     C                   MOVE      EBARID        EXARID                                        LN038
     C                   MOVE      EBRNAM        EXRNAM                                        LN038
     C                   MOVE      EBRSFX        EXRSFX                                        LN038
     C                   WRITE     MAEXPTD0                                                    LN038
     C*
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM DISTRIBUTE PROCESSING.                 *
     C*                                                               *
     C* CALLED FROM :  SPLFIL - Spool file processing.                *
     C* CALLS       :  SNGBCH - Single branch report processing.      *
     C*                BNKWDE - Bankwide report processing.           *
     C*                BRCHLV - Branch level processing.              *
     C*                COMLVL - Company levle report processing.      *
     C*                                                               *
     C* FIELDS      :  D5LVL  - Level.                                *
     C*****************************************************************
     C*
     C     DSTRBT        BEGSR
     C*
     C** IF DISTRIBUTION IS REQUIRED, USE
     C** SPOOL FILE ENTITY FOR DISTRIBUTION
     C*
     C     D5DRQD        IFEQ      'Y'
     C                   MOVE      D6XETY        ENTITY
     C                   END
     C*
     C** OTHERWISE, USE USER'S BRANCH/COMPANY CODE
     C*
     C     D5DRQD        IFEQ      'N'
     C*
      ** IF COMPANY LEVEL REPORT, ENTITY TO DISTRIBUTE TO IS COMPANY OF
      ***USER'S*DEFAULT*BRANCH*****************************************   142799
      *                                                                   142799
      ** User's default branch if entity is 'ALL' else use entity         142799
      ** of the report.                                                   142799
      *                                                                   142799
     C*
     C     D5LVL         IFEQ      'C'
      *                                                                   142799
     C     D5ETTY        IFEQ      'ALL'                                                       14279
     C     D6XETY        IFEQ      *BLANKS                                                     14279
     C*
     C** ACCESS USER'S DEFAULT BRANCH FOR COMPANY CODE
     C*
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM                    D5DBRN            3              I:User branch
     C********** P@BRCH    PARM P@BRCH    DSFDY              O:Rec format                     CGL029
     C     P@BRCH        PARM      P@BRCH        DSSDY
     C**
     C*  IF ACCESS PROGRAM ENDS IN ERROR, DATABASE ERROR.
     C*
     C     P@APRC        IFNE      *BLANK
     C                   MOVEL     'SDBRCHL1'    DBFILE                         *************
     C                   MOVEL     D5DBRN        DBKEY                          *           *
     C                   Z-ADD     5             DBASE                          * DBERR 005 *
     C                   EXSR      *PSSR                                        *           *
     C                   END
     C*
     C                   MOVE      A8CMCD        ENTITY            3
      *                                                                   142799
     C                   ELSE                                                                  14279
     C                   MOVE      D6XETY        ENTITY                                        14279
     C                   END                                                                   14279
      *                                                                   142799
     C                   ELSE                                                                  14279
     C                   MOVE      D5ETTY        ENTITY                                        14279
     C                   END                                                                   14279
     C*
     C                   END
     C*
     C*
     C***IF*LEVEL*IS*BRANCH,*DISTRIBUTE*TO*USER'S*DEFAULT*BRANCH*******   142799
      *                                                                   142799
      ** If level is branch, distribute to branch of report               142799
      *                                                                   142799
     C     D5LVL         IFEQ      'B'
     C***********          MOVE D5DBRN    ENTITY                          142799
      *                                                                   142799
      ** If entity is 'ALL' use the entity of spool file when             142799
      ** distributing.                                                    142799
      *                                                                   142799
     C     D5ETTY        IFEQ      'ALL'                                                       14279
     C     D6XETY        ANDNE     *BLANKS                                                     14279
     C                   MOVE      D6XETY        ENTITY                                        14279
     C                   ELSE                                                                  14279
     C                   MOVE      D5ETTY        ENTITY                                        14279
     C                   END                                                                   14279
     C                   END
      *                                                                                       CFC003
      ** Setup Entity for Department level                                                    CFC003
      *                                                                                       CFC003
     C     D5LVL         IFEQ      'D'
     C     CFC003        ANDEQ     'Y'
     C                   MOVE      D5ETTY        ENTITY
     C                   ENDIF
     C*
     C                   END
     C*
     C** DISTRIBUTE SPOOLED OUTPUT.
     C*
     C** IF LEVEL IS BLANK, SINGLE BRANCH SYSTEM
     C*
     C     D5LVL         CASEQ     *BLANK        SNGBCH
     C*
     C** IF LEVEL IS 'S'  CONSOLIDATED REPORT
     C*
     C     D5LVL         CASEQ     'S'           BNKWDE
     C*
     C** IF LEVEL IS 'B'/'C' DISTRIBUTE TO BRANCH/COMPANY
     C*
     C                   CAS                     ETTYLV
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM SINGLE BRANCH REPORT PROCESSING        *
     C*                                                               *
     C* CALLED FROM :  DSTRBT - Distribute processing.                *
     C* CALLS       :  DSTRBL - Distribution list processing.         *
     C*                USERID - User id processing.                   *
     C*                STNDIN - Standard instuction processing.       *
     C*                                                               *
     C* FIELDS      :  D5DLS1 - Distribution list part 1.             *
     C*                D5DLS2 - Distribution list part 2.             *
     C*                D5USRO - User id for output.                   *
     C*                D5SOID - Instruction identifier.               *
     C*                D5LVL  - Level.                                *
     C*                D5ETTY - Entity.                               *
     C*                D6PSTS - Status.                               *
     C*****************************************************************
     C*
     C     SNGBCH        BEGSR
     C*
     C** IF DISTRIBUTION LIST PART 1/2 ARE NOT BLANK DISTRIBUTE VIA LIST
     C*
     C     D5DLS1        IFNE      *BLANKS
     C     D5DLS2        ANDNE     *BLANKS
     C                   EXSR      DSTRBL
     C                   END
     C*
     C** IF USER ID FOR OUTPUT IS NOT BLANK DISTRIBUTE TO USER
     C*
     C     D5USRO        IFNE      *BLANKS
     C                   EXSR      USERID
     C                   END
     C*
     C** IF INSTRUCTION ID IS NOT EQUAL TO BLANKS THEN
     C** ACCESS LF/FCSOUTL1 VIA ACCESS PROGRAM.
     C*
     C     D5SOID        IFNE      *BLANKS
     C                   CALL      'AOSOUTR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM      D5SOID        SOID             10              I:Instruct ID
     C                   PARM      *ALL'*'       LVL               1              I:Level
     C                   PARM      *ALL'*'       ETTY              3              I:Entity
     C     P@SOUT        PARM      P@SOUT        DSFDY                            O:Rec format
     C*
     C** IF RECORD NOT FOUND ON LF/FCSOUTL1 SET NEW STATUS TO 'D'.
     C*
     C     P@APRC        IFNE      *BLANK
     C                   MOVE      'D'           STATUS            1
     C                   ELSE
     C*
      ** IF RECORD IS FOUND, DISTRIBUTE VIA STANDARD OUTPUT INSTRUCTIONS
     C*
     C                   EXSR      STNDIN
     C                   END
     C*
     C                   END
     C*
     C** IF DISTRIBUTION LIST PART 1/2, USER ID FOR OUTPUT,AND
     C** INSTRUCTION ID ARE BLANK SET NEW STATUS TO 'D' FOR DISTRIBUTED
     C*
     C     D5DLS1        IFEQ      *BLANKS
     C     D5DLS2        ANDEQ     *BLANKS
     C     D5USRO        ANDEQ     *BLANKS
     C     D5SOID        ANDEQ     *BLANKS
     C                   MOVE      'D'           STATUS
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM BANKWIDE REPORT PROCESSING.            *
     C*                                                               *
     C* CALLED FROM :  DSTRBT - Distribute processing.                *
     C* CALLS       :  DSTRBL - Distribution list processing.         *
     C*                USERID - User id processing.                   *
     C*                STNDIN - Standard instuction processing.       *
     C*                                                               *
     C* FIELDS      :  D5DLS1 - Distribution list part 1.             *
     C*                D5DLS2 - Distribution list part 2.             *
     C*                D5USRO - User id for output.                   *
     C*                D5SOID - Instruction identifier.               *
     C*                D5LVL  - Level.                                *
     C*                D5ETTY - Entity.                               *
     C*                D6PSTS - Status.                               *
     C*****************************************************************
     C*
     C     BNKWDE        BEGSR
     C*
     C** IF DISTRIBUTION LIST PART 1/2 ARE NOT BLANK DISTRIBUTE VIA LIST
     C*
     C     D5DLS1        IFNE      *BLANKS
     C     D5DLS2        ANDNE     *BLANKS
     C                   EXSR      DSTRBL
     C                   END
     C*
     C** IF USER ID FOR OUTPUT IS NOT BLANK DISTRIBUTE TO USER
     C*
     C     D5USRO        IFNE      *BLANKS
     C                   EXSR      USERID
     C                   END
     C*
     C** IF INSTRUCTION ID IS NOT EQUAL TO BLANKS THEN ACCESS
     C** LF/FCSOUTL1 VIA ACCESS PROGRAM WITH KEY AS INSTRUCTION ID.
     C*
     C     D5SOID        IFNE      *BLANK
      *                                                                                       CFC003
      ** CFC003 - Check Standard output instruction With User Dept.                           CFC003
      *                                                                                       CFC003
     C                   MOVE      *BLANK        P@APRC            7
     C     CFC003        IFEQ      'Y'
      *                                                                                       CFC003
      ** Retreive job user Department                                                         CFC003
      *                                                                                       CFC003
     C     D5USRO        IFEQ      *BLANKS                                      except when output u
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANK        P@APRC                           B:Return code
     C                   PARM      '*KEY'        P@APOP                           I:Option
     C                   PARM                    D5USRR                           I:user for Request
     C     P@USER        PARM      P@USER        DSSDY                            O:Rec format
     C                   ENDIF
      *                                                                                       CFC003
      ** If Acces Program ends in error database error.                                       CFC003
      *                                                                                       CFC003
     C     P@APRC        IFEQ      *BLANK                                         user details found
     C                   CALL      'AOSOUTR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM      D5SOID        SOID                             I:Instruct ID
     C                   PARM      'D'           LVL                              I:Level
     C                   PARM      DPPT          ETTY                             I:Entity
     C     P@SOUT        PARM      P@SOUT        DSFDY                            O:Rec format
     C                   ENDIF                                                    user details found
      *                                                                                       CFC003
     C                   ENDIF                                                    CFC003
      *                                                                                       CFC003
     C     CFC003        IFEQ      'N'                                          Feature not active
     C     CFC003        OREQ      'Y'                                           or Feature active
     C     P@APRC        ANDNE     *BLANKS                                       but not found, Std
      *                                                                                       CFC003
     C                   CALL      'AOSOUTR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM      D5SOID        SOID                             I:Instruct ID
     C                   PARM      D5LVL         LVL                              I:Level
     C                   PARM      *ALL'*'       ETTY                             I:Entity
     C     P@SOUT        PARM      P@SOUT        DSFDY                            O:Rec format
     C                   ENDIF
     C*
     C** IF RECORD NOT FOUND ACCESS LF/FCSOUTL1 VIA ACCESS PROGRAM
     C** WITH KEY AS INSTRUCTION ID ONLY
     C*
     C     P@APRC        IFNE      *BLANK
     C                   CALL      'AOSOUTR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM      D5SOID        SOID                             I:Instruct ID
     C                   PARM      *ALL'*'       LVL                              I:Level
     C                   PARM      *ALL'*'       ETTY                             I:Entity
     C     P@SOUT        PARM      P@SOUT        DSFDY                            O:Rec format
     C                   END
     C*
     C** IF RECORD NOT FOUND ACCESS LF/FCSOUTL1 VIA ACCESS PROGRAM
     C** WITH KEY AS LEVEL ONLY
     C*
     C     P@APRC        IFNE      *BLANK
     C                   CALL      'AOSOUTR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM      *ALL'*'       SOID                             I:Instruct ID
     C                   PARM      D5LVL         LVL                              I:Level
     C                   PARM      *ALL'*'       ETTY                             I:Entity
     C     P@SOUT        PARM      P@SOUT        DSFDY                            O:Rec format
     C                   END
     C*
     C** IF RECORD NOT FOUND SET NEW STATUS TO 'D'
     C*
     C     P@APRC        IFNE      *BLANK
     C                   MOVE      'D'           STATUS
     C                   ELSE
     C*
      ** OTHERWISE, USE STANDARD OUTPUT INSTRUCTIONS
     C*
     C                   EXSR      STNDIN
     C                   END
     C*
     C                   END
     C*
     C** IF DISTRIBUTION LIST PART 1/2, USER ID FOR OUTPUT, AND
     C** INSTRUCTION ID ARE BLANK ACCESS LF/FCSOUTL1 VIA ACCESS
     C** PROGRAM WITH KEY AS LEVEL.
     C*
     C     D5DLS1        IFEQ      *BLANKS
     C     D5DLS2        ANDEQ     *BLANKS
     C     D5USRO        ANDEQ     *BLANKS
     C     D5SOID        ANDEQ     *BLANKS
     C                   CALL      'AOSOUTR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM      *ALL'*'       SOID                             I:Instruct ID
     C                   PARM      D5LVL         LVL                              I:Level
     C                   PARM      *ALL'*'       ETTY                             I:Entity
     C     P@SOUT        PARM      P@SOUT        DSFDY                            O:Rec format
     C*
     C** IF RECORD NOT FOUND SET NEW STATUS TO 'D'
     C*
     C     P@APRC        IFNE      *BLANK
     C                   MOVE      'D'           STATUS
     C                   ELSE
     C*
      ** OTHERWISE USE STANDARD OUTPUT INSTRUCTIONS
     C*
     C                   EXSR      STNDIN
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM ENTITY LEVEL REPORT PROCESSING.        *
     C*                                                               *
     C* CALLED FROM :  DSTRBT - Distribute processing.                *
     C* CALLS       :  DSTRBL - Distribution list processing.         *
     C*                USERID - User id processing.                   *
     C*                STNDIN - Standard instuction processing.       *
     C*                                                               *
     C* FIELDS      :  D5DRQD - Distribution required.                *
     C*                D5DLS1 - Distribution list part 1.             *
     C*                D5DLS2 - Distribution list part 2.             *
     C*                D5USRO - User id for output.                   *
     C*                D5SOID - Instruction identifier.               *
     C*                D5LVL  - Level.                                *
     C*                D5ETTY - Entity.                               *
     C*                D6PSTS - Status.                               *
     C*****************************************************************
     C*
     C     ETTYLV        BEGSR
     C*
     C** IF DISTRIBUTION LIST PART 1/2 ARE NOT BLANK DISTRIBUTE VIA LIST
     C*
     C     D5DLS1        IFNE      *BLANKS
     C     D5DLS2        ANDNE     *BLANKS
     C                   EXSR      DSTRBL
     C                   END
     C*
     C** IF USER ID FOR OUTPUT IS NOT BLANK SEND TO USER'S OUTPUT QUEUE
     C*
     C     D5USRO        IFNE      *BLANKS
     C                   EXSR      USERID
     C                   END
     C*
     C** IF INSTRUCTION ID IS NOT BLANK ACCESS LF/FCSOUTL1 VIA ACCESS
     C** PROGRAM WITH KEY AS INSTRUCTION ID, LEVEL, AND ENTITY.
     C*
     C     D5SOID        IFNE      *BLANK
     C*
     C                   CALL      'AOSOUTR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM                    D5SOID                           I:Instruct ID
     C                   PARM                    D5LVL                            I:Level
     C                   PARM                    ENTITY                           I:Entity
     C     P@SOUT        PARM      P@SOUT        DSFDY                            O:Rec format
     C*
     C** IF RECORD NOT FOUND ACCESS LF/FCSOUTL1 VIA ACCESS PROGRAM
     C** WITH KEY AS INSTRUCTION ID.
     C*
     C     P@APRC        IFNE      *BLANK
     C                   CALL      'AOSOUTR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM      D5SOID        SOID                             I:Instruct id
     C***********          PARM *ALL'*'   LVL                I:Level      142799
     C                   PARM      'S'           LVL                              I:Level      14279
     C                   PARM      *ALL'*'       ETTY                             I:Entity
     C     P@SOUT        PARM      P@SOUT        DSFDY                            O:Rec format
     C                   END
      *                                                                   142799
      ** If record not found access LF/FCSOUTL1 via access program        142799
      ** with key as Instruction Id.                                      142799
      *                                                                   142799
     C     P@APRC        IFNE      *BLANK                                                      14279
     C                   CALL      'AOSOUTR0'                                                  14279
     C                   PARM      *BLANK        P@APRC            7              B:Return code14279
     C                   PARM      '*KEY'        P@APOP            7              I:Option     14279
     C                   PARM      D5SOID        SOID                             I:Instruct id14279
     C                   PARM      *ALL'*'       LVL                              I:Level      14279
     C                   PARM      *ALL'*'       ETTY                             I:Entity     14279
     C     P@SOUT        PARM      P@SOUT        DSFDY                            O:Rec format 14279
     C                   END                                                                   14279
     C*
     C** IF RECORD NOT FOUND ACCESS LF/FCSOUTL1 VIA ACCESS PROGRAM
     C** WITH KEY AS LEVEL AND ENTITY.
     C*
     C     P@APRC        IFNE      *BLANK
     C                   CALL      'AOSOUTR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM      *ALL'*'       SOID                             I:Instruct id
     C                   PARM      D5LVL         LVL                              I:Level
     C                   PARM      ENTITY        ETTY                             I:Entity
     C     P@SOUT        PARM      P@SOUT        DSFDY                            O:Rec format
     C                   END
     C*
     C** IF NO RECORDS FOUND SET NEW STATUS TO 'D' FOR DISTRIBUTED
     C*
     C     P@APRC        IFNE      *BLANK
     C                   MOVE      'D'           STATUS
     C                   ELSE
     C*
      ** DISTRIBUTE VIA STANDARD OUTPUT INSTRUCTIONS IF ANY FOUND
     C*
     C                   EXSR      STNDIN
     C                   END
     C*
     C                   END
     C*
     C** IF DISTRIBUTION LIST PART 1/2, USER ID FOR OUTPUT, AND
     C** INSTRUCTION ID ARE BLANK ACCESS LF/FCSOUTL1 VIA ACCESS
     C** PROGRAM WITH KEY AS LEVEL AND ENTITY.
     C*
     C     D5DLS1        IFEQ      *BLANKS
     C     D5DLS2        ANDEQ     *BLANKS
     C     D5USRO        ANDEQ     *BLANKS
     C     D5SOID        ANDEQ     *BLANKS
     C                   CALL      'AOSOUTR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM      *ALL'*'       SOID                             I:Instruct id
     C                   PARM      D5LVL         LVL                              I:Level
     C                   PARM      ENTITY        ETTY                             I:Entity
     C     P@SOUT        PARM      P@SOUT        DSFDY                            O:Rec format
     C*
     C** IF RECORD NOT FOUND SET NEW STATUS TO 'D' FOR DISTRIBUTED
     C*
     C     P@APRC        IFNE      *BLANK
     C                   MOVE      'D'           STATUS
     C*
      ** OTHERWISE, DISTRIBUTE VIA STANDARD OUTPUT INSTRUCTIONS
     C*
     C                   ELSE
     C                   EXSR      STNDIN
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM DISTRIBUTION LIST PROCESSING.          *
     C*                                                               *
     C* CALLED FROM :  SNGBCH - Single branch report processing.      *
     C*                BNKWDE - Bankwide report processing.           *
     C*                BRCHLV - Branch level processing.              *
     C*                COMLVL - Company levle report processing.      *
     C* CALLS       :  NONE                                           *
     C*                                                               *
     C* FIELDS      :  EBRNAM - Report name.                          *
     C*                EBRSFX - Print suffix.                         *
     C*                D5JBNM - Job name.                             *
     C*                D5JUSR - User name.                            *
     C*                D5JBNB - Job number.                           *
     C*                D6SFNO - Spool file number.                    *
     C*                D6PSTS - Status.                               *
     C*****************************************************************
     C*
     C     DSTRBL        BEGSR
     C*
     C** CALL FCC0403 TO SEND SPOOL FILE REQUIRED TO THE USER SPECIFIED
     C** AND RETURN FILE NOT FOUND FLAG.
     C*
     C                   CALL      'FCC0403'
     C                   PARM                    FILNAM
     C                   PARM                    D5JBNM
     C                   PARM                    D5JUSR
     C                   PARM                    D5JBNB
     C                   PARM                    D6SFNO
     C                   PARM      *BLANK        FILNFF
     C                   PARM                    D5DLS1
     C                   PARM                    D5DLS2
     C*
     C***IF*FILE*NOT*FOUND*FLAG*IS*EQUAL*TO*'Y**SET*NEW*STATUS*TO*PRINTED LN0852
     C***OTHERWISE*SET*NEW*STATUS*TO*'D'.***                              LN0852
     C*
     C********** FILNFF    IFEQ 'Y'                                       LN0852
     C**********           MOVE 'P'       STATUS                          LN0852
     C**********           ELSE                                           LN0852
     C**********           MOVE 'D'       STATUS                          LN0852
     C**********           END                                            LN0852
     C*
     C* IF ERROR FLAG RETURNS AS BLANK (NO ERROR) SET STATUS TO 'D',      LN0852
     C* ELSE SET STATUS TO VALUE OF FLAG: 'P' - PRINTED                   LN0852
     C*                                OR 'Y' - ABNORMAL.                 LN0852
     C     FILNFF        IFEQ      *BLANK                                                      LN085
     C                   MOVEL     'D'           STATUS                                        LN085
     C                   ELSE                                                                  LN085
     C                   MOVEL     FILNFF        STATUS                                        LN085
     C                   END                                                                   LN085
     C*                                                                   LN0852
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM USER ID PROCESSING.                    *
     C*                                                               *
     C* CALLED FROM :  SNGBCH - Single branch report processing.      *
     C*                BNKWDE - Bankwide report processing.           *
     C*                BRCHLV - Branch level processing.              *
     C*                COMLVL - Company levle report processing.      *
     C* CALLS       :  NONE                                           *
     C*                                                               *
     C* FIELDS      :  EBRNAM - Report name.                          *
     C*                EBRSFX - Print suffix.                         *
     C*                D1OUTQ - Output queue.                         *
     C*                D1NCPY - Number of copies.                     *
     C*                D1HLDB - Hold before printing.                 *
     C*                D1SSPF - Save after printing.                  *
     C*                D5JBNM - Job name.                             *
     C*                D5JUSR - User name.                            *
     C*                D5JBNB - Job number.                           *
     C*                D6SFNO - Spool file number.                    *
     C*                D6PSTS - Status.                               *
     C*****************************************************************
     C*
     C     USERID        BEGSR
     C*
     C** ACCESS OUTPUT QUEUE OF USER FROM LF/MUSER VIA ACCESS PROGRAM
     C*
     C                   CALL      'AOUSERR0'
.    C                   PARM      *BLANK        P@APRC                           B:Return code
     C                   PARM      '*KEY'        P@APOP                           I:Option
     C                   PARM                    D5USRO                           I:UserID otpt
     C***********P@USER    PARM P@USER    DSFDY              O:Rec format 087380
     C     P@USER        PARM      P@USER        DSSDY                            O:Rec format 08738
     C*
     C** IF ACCES PROGRAM ENDS IN ERROR DATABASE ERROR.
     C*
     C     P@APRC        IFNE      *BLANK
     C                   MOVEL     'MUSER'       DBFILE                         *************
     C                   MOVEL     D5USRO        DBKEY                          *           *
     C                   Z-ADD     6             DBASE                          * DBERR 006 *
     C                   EXSR      *PSSR                                        *           *
     C                   END                                                    *************
     C*
     C** IF OUTPUT QUEUE OF USER IS NOT EQUAL TO BLANK
     C*
     C     OUTQ          IFNE      *BLANK
     C*
     C** CALL FCC0404 TO CHANGE THE SPOOL FILE ATTRIBUTES OF THE FILE
     C** TO BE DISTRIBUTED, AND RETURN FILE NOT FOUND FLAG.
     C** SET FILE NOT FOUND FLAG TO BLANKS, OUTPUT QUEUE TO USER OUTPUT
     C** QUEUE, NUMBER OF COPIES TO 1, SAVE TO NO, AND HOLD TO NO.
     C*
     C                   CALL      'FCC0404'
     C                   PARM                    FILNAM
     C                   PARM                    D5JBNM
     C                   PARM                    D5JUSR
     C                   PARM                    D5JBNB
     C                   PARM                    D6SFNO
     C                   PARM      OUTQ          D1OUTQ           10
     C                   PARM      1             D1NCPY            2 0
     C                   PARM      'N'           D1HLDB            1
     C                   PARM      'N'           D1SSPF            1
     C                   PARM      *BLANK        FILNFF
     C                   PARM      *BLANK        W@OUTQ
     C                   PARM      *BLANK        MFLAG
      *                                                                                       CFC002
     C/COPY WNCPYSRC,FC0100C001
     C*
     C***IF*FILE*NOT*FOUND*FLAG*IS*EQUAL*TO*'Y**SET*NEW*STATUS*TO*'P'**   LN0852
     C***OTHERWISE*SET*NEW*STATUS*TO*'D'.***                              LN0852
     C*
     C********** FILNFF    IFEQ 'Y'                                       LN0852
     C**********           MOVE 'P'       STATUS                          LN0852
     C**********           ELSE                                           LN0852
     C**********           MOVE 'D'       STATUS                          LN0852
     C**********           END                                            LN0852
     C*
     C* IF ERROR FLAG RETURNS AS BLANK (NO ERROR) SET STATUS TO 'D',      LN0852
     C* ELSE SET STATUS TO VALUE OF FLAG: 'P' - PRINTED                   LN0852
     C*                                OR 'Y' - ABNORMAL.                 LN0852
     C     FILNFF        IFEQ      *BLANK                                                      LN085
     C                   MOVEL     'D'           STATUS                                        LN085
     C                   ELSE                                                                  LN085
     C                   MOVEL     FILNFF        STATUS                                        LN085
     C                   END                                                                   LN085
     C*                                                                   LN0852
     C** IF OUTPUT QUEUE IS EQUAL TO BLANK SET STATUS TO DISTRIBUTED
     C*
     C                   ELSE
     C                   MOVE      'D'           STATUS
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM STANDARD INSTRUCTIONS PROCESSING.      *
     C*                                                               *
     C* CALLED FROM :  SNGBCH - Single branch report processing.      *
     C*                BNKWDE - Bankwide report processing.           *
     C*                BRCHLV - Branch level processing.              *
     C*                COMLVL - Company levle report processing.      *
     C* CALLS       :  NONE                                           *
     C*                                                               *
     C* FIELDS      :  EBRNAM - Report name.                          *
     C*                EBRSFX - Print suffix.                         *
     C*                D5JBNM - Job name.                             *
     C*                D5JUSR - User name.                            *
     C*                D5JBNB - Job number.                           *
     C*                D6SFNO - Spool file number.                    *
     C*                D1OUTQ - Output queue.                         *
     C*                D1NCPY - Number of copies.                     *
     C*                D1HLDB - Hold before printing.                 *
     C*                D1SSPF - Save after printing.                  *
     C*                D6PSTS - Status.                               *
     C*****************************************************************
     C*
     C     STNDIN        BEGSR
      *                                                                                       CFC002
     C     CFC002        IFEQ      'Y'
     C                   MOVEL     D1QUE1        WXOUTQ           20
     C                   MOVE      D1QUE2        WXOUTQ
     C                   MOVEL     WXOUTQ        W@OUTQ           30
     C                   MOVE      D1QUE3        W@OUTQ
      *                                                                                       CFC002
     C     1             CHAIN     MAFOQPD0                           54
      *                                                                                       CFC002
      ** If record found, retrieve indicator                                                  CFC002
      *                                                                                       CFC002
     C     *IN54         IFEQ      '0'
     C                   MOVE      MFMCRO        MFLAG             1
     C                   ENDIF
     C                   ENDIF
     C*
     C** CALL FCC0404 TO CHANGE THE SPOOL FILE ATTRIBUTES OF THE FILE
     C** TO BE DISTRIBUTED, AND RETURN FILE NOT FOUND FLAG.
     C*
     C                   MOVE      D1NCPY        NOCPY             2
     C                   CALL      'FCC0404'
     C                   PARM                    FILNAM
     C                   PARM                    D5JBNM
     C                   PARM                    D5JUSR
     C                   PARM                    D5JBNB
     C                   PARM                    D6SFNO
     C                   PARM                    D1OUTQ
     C                   PARM                    NOCPY
     C                   PARM                    D1SSPF
     C                   PARM                    D1HLDB
     C                   PARM      *BLANK        FILNFF
     C                   PARM                    W@OUTQ
     C                   PARM                    MFLAG
      *                                                                                       CFC002
     C/COPY WNCPYSRC,FC0100C002
     C*
     C***IF*FILE*NOT*FOUND*FLAG*IS*EQUAL*TO*'Y'*SET*NEW*STATUS*TO*'P'**   LN0852
     C***OTHERWISE*SET*NEW*STATUS*TO*'D'.***                              LN0852
     C*
     C********** FILNFF    IFEQ 'Y'                                       LN0852
     C**********           MOVE 'P'       STATUS                          LN0852
     C**********           ELSE                                           LN0852
     C**********           MOVE 'D'       STATUS                          LN0852
     C**********           END                                            LN0852
     C*
     C* IF ERROR FLAG RETURNS AS BLANK (NO ERROR) SET STATUS TO 'D',      LN0852
     C* ELSE SET STATUS TO VALUE OF FLAG: 'P' - PRINTED                   LN0852
     C*                                OR 'Y' - ABNORMAL.                 LN0852
     C     FILNFF        IFEQ      *BLANK                                                      LN085
     C                   MOVEL     'D'           STATUS                                        LN085
     C                   ELSE                                                                  LN085
     C                   MOVEL     FILNFF        STATUS                                        LN085
     C                   END                                                                   LN085
     C*                                                                   LN0852
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM UPDATE SPOOL FILE NUMBERS PROCESSING.  *
     C*                                                               *
     C* CALLED FROM :  SPLFIL - Spool file processing.                *
     C* CALLS       :  NONE                                           *
     C*                                                               *
     C* FIELDS      :  D6RNAM - Report name.                          *
     C*                D6RQSQ - Sequence number.                      *
     C*                D6SFNO - Spool file numbers.                   *
     C*****************************************************************
     C*
     C     SPLFNO        BEGSR
     C*
     C** ACCESS LF/FCSFNOL0 FOR THIS REPORT/SEQUENCE/SPOOL FILE NUMBER.
     C*
     C     SFNOK         CHAIN     FCSFNOL0                           13
     C*
     C** IF RECORD NOT FOUND DATABASE ERROR.
     C*
     C     *IN13         IFEQ      '1'
     C                   MOVEL     'FCSFNOL0'    DBFILE                         *************
     C                   MOVEL     RPSSFN        DBKEY                          *           *
     C                   Z-ADD     7             DBASE                          * DBERR 007 *
     C                   EXSR      *PSSR                                        *           *
     C                   END                                                    *************
     C*
     C** UPDATE SPOOL FILE NUMBERS FILE WITH NEW STATUS.
     C*
     C                   MOVE      STATUS        D6PSTS
     C                   UPDATE    @D6REJB
     C                   COMMIT
     C*
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM DATABASE ERROR PROCESSING.             *
     C*                                                               *
     C* CALLED FROM :  MAIN CODE.                                     *
     C* CALLS       :  NONE.                                          *
     C*****************************************************************
     C*
     C     *PSSR         BEGSR
     C*
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   END
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
** CPY@
(c) Finastra International Limited 2001

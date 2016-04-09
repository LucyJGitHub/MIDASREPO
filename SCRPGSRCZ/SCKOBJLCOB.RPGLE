     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*X**A***OVRDBF*FILE(OBJLCK)*TOFILE(OBJECTLOCK)************************                      BUG6221
/*XBIA*  OVRDBF FILE(OBJLCK) TOFILE(OBJECTLOCK) LVLCHK(*NO)           *                      BUG6221
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas SC Kill Object Locks in COB')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  SCKOBJLCOB - Kill Object Locks in COB                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD024937           Date 07May14               *
      *  Prev Amend No. MD021351           Date 06May14               *
      *                 AR584600           Date 10Jun13               *
      *                 CCB023             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 248878             Date 12Jun07               *
      *                 247277             Date 24May07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 237463             Date 21Jun06               *
      *                 240226             Date 05Jun06               *
      *                 BUG7214            Date 17May05               *
      *                 BUG6221            Date 11Apr05               *
      *                 BUG4846            Date 04Nov04               *
      *                 BUG4207            Date 07Sep04               *
      *                 BUG3834 *CREATE    Date 18Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024937 - SCKLEXTD works incorrectly in case file field     *
      *             contains symbol % in the first position           *
      *  MD021351 - Design for Kill object locks                      *
      *  AR584600 - SCKOBJLCB fails during COB, applied fix 255178.   *
      *             (Child: AR584601)                                 *
      *  CCB023 - COB Restructure - Restructure Input Cycle           *
      *           Termination Components                              *
      *  248878 - Error in user name in fix 247277.                   *
      *  247277 - Allow for native JDBC driver as well as toolbox.    *
      *  CRE026 - Consumer Banking                                    *
      *  237463 - Complete BUG4846 with IMMED option.                 *
      *           Fix applied by 240226.                              *
      *  240226 - Complete BUG4846 with IMMED option.                 *
      *  BUG7214 - Incomplete fix BUG4846, add ENDJOB with *IMMED     *
      *  BUG6221 - Do not perform level-checking on file OBJLCK.      *
      *  BUG4846 - SCKOBJLCB ends unnecessarily.                      *
      *            Also do ENDJOB with *IMMED                         *
      *  BUG4207 - Program falls over if job is already ending        *
      *  BUG3834 - New programs created to deal with object locks     *
      *                                                               *
      *****************************************************************
 
     FOBJLCK    UP   E           K DISK    INFSR(*PSSR) RENAME(OBJECTLOCK: OLF)
     FMUSER     IF   E           K DISK    INFSR(*PSSR)
     FSCTRIGJ0  IF   E           K DISK    INFSR(*PSSR)
     FSCKLEXTD  IF   E             DISK    INFSR(*PSSR)                                     MD021351
     FCBCOMSL0  IF   E           K DISK    INFSR(*PSSR)                                     MD021351
     FQSYSPRT   O    F  132        PRINTER USROPN
 
     D J2E             S             28    DIM(999)
     D AJ              S             28    DIM(999)
 
     D RcdJ            S             28    DIM(9999)
     D RcdD            S            100    DIM(9999)
 
     D WQcmd           S              1    DIM(80) CTDATA PERRCD(80)
     D PosJN           S              3  0                                                  MD021351
     D PosJU           S              3  0                                                  MD021351
     D NTKJOBN         S              3                                                     MD021351
     D NTKJOBU         S              3                                                     MD021351
     D StrJobN         S              1  0                                                  MD021351
     D StrJobU         S              1  0                                                  MD021351
 
     D SDSTAT        E DS
      *                                                                                      BUG4207
      * Program Status Data Structure layout                                                 BUG4207
     DPSDS            SDS                                                                    BUG4207
      **  Exception type & number                                                            BUG4207
     D PSException            40     46                                                      BUG4207
 
     D JUNDS           DS
      * Job/User/Number
     D  JUN                    1     28
     D  JOBNAME                1     10
     D  SLASH1                11     11
     D  JOBUSER               12     21
     D  SLASH2                22     22
     D  JOBNUMBER             23     28
 
 
     C     JOBNAME       CABEQ     *BLANK        IGNREC
 
     C**********         MOVE      'N'           UpdateRecd        1
     C                   MOVE      'Y'           UpdateRecd        1                        MD021351
     C                   EXSR      CKNTBK                                                   MD021351
                                                                                            MD021351
      ** Do not kill COB component                                                          MD021351
     C     JOBNAME       CHAIN     CBCOMSL0                           80                    MD021351
     C                   IF        *IN80 = '0'                                              MD021351
     C                   MOVE      'N'           UpdateRecd                                 MD021351
     C                   ENDIF                                                              MD021351
 
     C                   EVAL      SLASH1 = '/'
     C                   EVAL      SLASH2 = '/'
 
     C                   EVAL      Record =  OBJECT + OBJECTLIB + OBJECTTYPE +
     C                                       JOBNAME + JOBUSER + JOBNUMBER  +
     C                                       LOCKSTATE + JOBUSERID + IPADDRESS
 
     C                   Z-add     1             R                 5 0
     C     Record        LOOKUP    RcdD(R)                                99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    RcdD(R)                                99
     C                   EVAL      RcdJ(R) = JUN
     C                   EVAL      RcdD(R) = Record
     C                   ENDIF
 
O
      **If*web-facing*job*and*user*on*on*MUSERDD***********************                     MD021351
      *****Select*for*killing******************************************                     MD021351
      *****************************************************************                     MD021351
     C**********         IF        %subst(JOBNAME: 1: 2) = 'QQ'                             MD021351
     C*****JOBUSERID     CHAIN     MUSERDDF                           99                    MD021351
     C******IN99         IFEQ      *OFF                                                     MD021351
     C**********         EVAL      SHARE = '!'                                              MD021351
     C**********         EVAL      UpdateRecd = 'Y'                                         MD021351
     C**********         ENDIF                                                              MD021351
     C**********         ENDIF                                                              MD021351
      *****************************************************************                     MD021351
      **If*QZDASOINIT*job*and*jobuser*is*xxWEBUSER*********************                     MD021351
      ***If*file*is*on*SCTRIGJ0****************************************                     MD021351
      ***or*if*file*doesn't*have*a*lock*state*of**SHRRD****************                     MD021351
      *****Select*for*killing******************************************                     MD021351
      *****************************************************************                     MD021351
     C**********         IF        JOBNAME = 'QZDASOINIT'                                   MD021351
     C**********                   and JOBUSERID = WebUser                                  MD021351
     C**********                   OR JOBNAME = 'QZDASOINIT'                                MD021351
     C**********                   and JOBUSERID = 'QUSER'                                  MD021351
     C**********                   OR JOBNAME = 'QSQSRVR'                            247277 MD021351
     C***********                  and JOBUSERID = 'QUSER'                             247277 248878
     C**********                   and JOBUSERID = WebUser                           248878 MD021351
     C**********                   OR JOBNAME = 'QSQSRVR'                            247277 MD021351
     C**********                   and JOBUSERID = 'QUSER'                           247277 MD021351
     C*****SCTRIGK       CHAIN     SCTRIGJ0                           99                    MD021351
     C******IN99         IFEQ      *OFF                                                     MD021351
     C*****LOCKSTATE     ORNE      '*SHRRD'                                                 MD021351
     C**********         EVAL      SHARE = '!'                                              MD021351
     C**********         EVAL      UpdateRecd = 'Y'                                         MD021351
     C**********         ELSE                                                      AR584600 MD021351
     C**********         EVAL      SHARE = '!'                                     AR584600 MD021351
     C**********         EVAL      UpdateRecd = 'Y'                                AR584600 MD021351
     C**********         ENDIF                                                              MD021351
     C**********         ENDIF                                                              MD021351
 
      * Update OBJLCK
      * and add job to list of jobs to end
 
     C                   IF        UpdateRecd = 'Y'
     C                   UPDATE    OLF
     C     JUN           LOOKUP    J2E                                    99
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     1             X                 3 0
     C     *BLANK        LOOKUP    J2E(X)                                 99
     C                   MOVEL     JUN           J2E(X)
     C                   ENDIF
     C                   ENDIF
 
      * Add job to list of all jobs
 
     C     JUN           LOOKUP    AJ                                     99
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     1             X                 3 0
     C     *BLANK        LOOKUP    AJ(X)                                  99
     C                   MOVEL     JUN           AJ(X)
     C                   ENDIF
 
     C     IGNREC        TAG
 
     CLR                 EXSR      ENDJOBS
     CLR                 EXSR      RPTJOBSNEND
     CLR                 EXSR      RPTLCKSEND
     CLR                 EXSR      RPTLCKSNEND
     C/SPACE 5
      *****************************************************************                     MD021351
      *                                                               *                     MD021351
      *  CKNTBK - Ignore Records if it exist in jobs not to be killed *                     MD021351
      *                                                               *                     MD021351
      *****************************************************************                     MD021351
     C     CKNTBK        BEGSR                                                              MD021351
                                                                                            MD021351
     C     1             SETLL     SCKLEXTD                                                 MD021351
     C                   READ      SCKLEXTD                                                 MD021351
     C                   DOW       NOT %EOF(SCKLEXTD)                                       MD021351
                                                                                            MD021351
      ** Check if jobname is in jobs not to be killed                                       MD021351
                                                                                            MD021351
     C                   EVAL      PosJN = %SCAN('%':%TRIM(JOBNAM))                         MD021351
     C                   EVAL      NTKJOBN = 'No '                                          MD021351
                                                                                            MD021351
     C                   SELECT                                                             MD021351
                                                                                            MD021351
     C                   WHEN      PosJN > 1                                                MD021351
                                                                                            MD021351
     C                   IF        %SUBST(JOBNAME:1:(PosJN - 1)) =                          MD021351
     C                             %SUBST(JOBNAM:1:(PosJN - 1))                             MD021351
     C                   EVAL      NTKJOBN = 'Yes'                                          MD021351
     C                   ENDIF                                                              MD021351
                                                                                            MD021351
     C                   WHEN      PosJN = 1 AND                                            MD021351
     C                             %SUBST(JOBNAM:(PosJN + 1)) <> *BLANKS                    MD021351
     C**********         EVAL      StrJobN = PosJN + 1                             MD021351 MD024937
     C**********         IF        %SUBST(JOBNAME:StrJobN) =                       MD021351 MD024937
     C**********                   %SUBST(JOBNAM:StrJobN)                          MD021351 MD024937
                                                                                            MD024937
      ** Check 2nd wildcard (%) exists                                                      MD024937
     C                   EVAL      StrJobN = %SCAN('%':%TRIM(%SUBST(JOBNAM:2)))             MD024937
     C                   IF        StrJobN > 0                                              MD024937
                                                                                            MD024937
     C                   EVAL      StrJobN = %SCAN(%TRIM(%SUBST(JOBNAM:2:                   MD024937
     C                                       StrJobN-1)):JOBNAME)                           MD024937
     C                   IF        StrJobN > 0                                              MD024937
     C                   EVAL      NTKJOBN = 'Yes'                                          MD024937
     C                   ENDIF                                                              MD024937
                                                                                            MD024937
      ** Else no 2nd wildcard                                                               MD024937
     C                   ELSE                                                               MD024937
     C                   EVAL      StrJobN = %SCAN(%TRIM(%SUBST(JOBNAM:2))                  MD024937
     C                                       :JOBNAME)                                      MD024937
                                                                                            MD024937
     C                   IF        StrJobN > 0 AND                                          MD024937
     C                             %SUBST(JOBNAME:StrJobN) =                                MD024937
     C                             %SUBST(JOBNAM:2)                                         MD024937
     C                   EVAL      NTKJOBN = 'Yes'                                          MD021351
     C                   ENDIF                                                              MD021351
     C                   ENDIF                                                              MD024937
                                                                                            MD021351
     C                   WHEN      PosJN = 1 AND                                            MD021351
     C                             %SUBST(JOBNAM:(PosJN + 1)) = *BLANKS                     MD021351
     C                   EVAL      NTKJOBN = 'Yes'                                          MD021351
                                                                                            MD021351
     C                   WHEN      PosJN = 0                                                MD021351
     C                   IF        JOBNAME = JOBNAM                                         MD021351
     C                   EVAL      NTKJOBN = 'Yes'                                          MD021351
     C                   ENDIF                                                              MD021351
     C                   ENDSL                                                              MD021351
                                                                                            MD021351
      ** Check if jobuserid is in jobs not to be killed                                     MD021351
                                                                                            MD021351
     C                   EVAL      PosJU = %SCAN('%':%TRIM(JOBUSR))                         MD021351
     C                   EVAL      NTKJOBU = 'No '                                          MD021351
                                                                                            MD021351
     C                   SELECT                                                             MD021351
                                                                                            MD021351
     C                   WHEN      PosJU > 1                                                MD021351
                                                                                            MD021351
     C                   IF        %SUBST(JOBUSERID:1:(PosJU - 1)) =                        MD021351
     C                             %SUBST(JOBUSR:1:(PosJU - 1))                             MD021351
     C                   EVAL      NTKJOBU = 'Yes'                                          MD021351
     C                   ENDIF                                                              MD021351
                                                                                            MD021351
     C                   WHEN      PosJU = 1 AND                                            MD021351
     C                             %SUBST(JOBUSR:(PosJU + 1)) <> *BLANKS                    MD021351
                                                                                            MD021351
     C**********         EVAL      StrJobU = PosJU + 1                             MD021351 MD024937
     C**********         IF        %SUBST(JOBUSERID:StrJobU) =                     MD021351 MD024937
     C**********                   %SUBST(JOBUSR:StrJobU)                          MD021351 MD024937
                                                                                            MD024937
      ** Check 2nd wildcard (%) exists                                                      MD024937
     C                   EVAL      StrJobU = %SCAN('%':%TRIM(%SUBST(JOBUSR:2)))             MD024937
     C                   IF        StrJobU > 0                                              MD024937
                                                                                            MD024937
     C                   EVAL      StrJobU = %SCAN(%TRIM(%SUBST(JOBUSR:2:                   MD024937
     C                                       StrJobU-1)):JOBUSERID)                         MD024937
     C                   IF        StrJobU > 0                                              MD024937
     C                   EVAL      NTKJOBU = 'Yes'                                          MD024937
     C                   ENDIF                                                              MD024937
                                                                                            MD024937
      ** Else no 2nd wildcard                                                               MD024937
     C                   ELSE                                                               MD024937
     C                   EVAL      StrJobU = %SCAN(%TRIM(%SUBST(JOBUSR:2))                  MD024937
     C                                       :JOBUSERID)                                    MD024937
                                                                                            MD024937
     C                   IF        StrJobU > 0 AND                                          MD024937
     C                             %SUBST(JOBUSERID:StrJobU) =                              MD024937
     C                             %SUBST(JOBUSR:2)                                         MD024937
     C                   EVAL      NTKJOBU = 'Yes'                                          MD021351
     C                   ENDIF                                                              MD021351
     C                   ENDIF                                                              MD024937
                                                                                            MD021351
     C                   WHEN      PosJU = 1 AND                                            MD021351
     C                             %SUBST(JOBUSR:(PosJU + 1)) = *BLANKS                     MD021351
     C                   EVAL      NTKJOBU = 'Yes'                                          MD021351
                                                                                            MD021351
     C                   WHEN      PosJU = 0                                                MD021351
     C                   IF        JOBUSERID = JOBUSR                                       MD021351
     C                   EVAL      NTKJOBU = 'Yes'                                          MD021351
     C                   ENDIF                                                              MD021351
     C                   ENDSL                                                              MD021351
                                                                                            MD021351
      ** If jobname and jobuser are satisfy don't kill the job                              MD021351
                                                                                            MD021351
     C                   IF        NTKJOBN = 'Yes' AND                                      MD021351
     C                             NTKJOBU = 'Yes'                                          MD021351
     C                   EVAL      UpdateRecd = 'N'                                         MD021351
     C                   LEAVE                                                              MD021351
     C                   ENDIF                                                              MD021351
                                                                                            MD021351
     C                   READ      SCKLEXTD                                                 MD021351
     C                   ENDDO                                                              MD021351
     C                   ENDSR                                                              MD021351
      *****************************************************************                     MD021351
      /EJECT                                                                                MD021351
      ********************************************************************
      * ENDJOBS - End Jobs
      ********************************************************************
     C     ENDJOBS       BEGSR
 
     C                   Z-ADD     1             X
     C     X             DOWLE     999
     C     J2E(X)        ANDNE     *BLANK
 
     C                   EVAL      JUN = J2E(X)
 
     C                   EXSR      FMT_CMD
 
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    WQCmd
     C                   PARM      80            CommandLen       15 5
                                                                                             BUG4207
      * If job is already ending                                                             BUG4207
     C                   If        *In99 = *ON and                                           BUG4207
     C                             PSException = 'CPF1363'                                   BUG4207
     C                   Eval      WQCMD = %Trim(WQCMD) + ' ***Job already endi+             BUG4207
     C                             ng *CNTRLD***'                                            BUG4207
     C                   EndIf                                                               BUG4207
 
      * Open print File
     C                   IF        WREPORT = 'Y'                                              CCB023
     C                   EXSR      OPNPRTF
      * Report
     C                   MOVEA     WQCmd         WCMD             80
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    JOBENDD
     C                   ENDIF                                                                CCB023
 
     C                   ADD       1             X
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * RPTJOBSNEND - Report Jobs NOT Ended
      ********************************************************************
     C     RPTJOBSNEND   BEGSR
 
     C                   Z-ADD     1             X
     C     X             DOWLE     999
     C     AJ(X)         ANDNE     *BLANK
 
     C                   EVAL      JUN = AJ(X)
 
      * If not ended
 
     C     JUN           LOOKUP    J2E                                    99
     C     *IN99         IFEQ      *OFF
 
     C                   EXSR      FMT_CMD
 
      * Open print File
     C                   IF        WREPORT = 'Y'                                              CCB023
     C                   EXSR      OPNPRTF
      * Report
     C                   MOVEA     WQCmd         WCMD
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    JOBNENDD
     C                   ENDIF                                                                CCB023
 
     C                   ENDIF
 
     C                   ADD       1             X
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * RPTLCKSEND  - Report Locks Ended
      ********************************************************************
     C     RPTLCKSEND    BEGSR
 
     C                   Z-ADD     1             R
     C     R             DOWLE     9999
     C     RcdD(R)       ANDNE     *BLANK
 
     C                   EVAL      JUN    = RcdJ(R)
     C                   EVAL      Record = RcdD(R)
 
      * If ended
 
     C     JUN           LOOKUP    J2E                                    99
     C     *IN99         IFEQ      *ON
 
      * Open print File
     C                   IF        WREPORT = 'Y'                                              CCB023
     C                   EXSR      OPNPRTF
      * Report
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    LCKENDD
     C                   ENDIF                                                                CCB023
 
     C                   ENDIF
 
     C                   ADD       1             R
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * RPTLCKSNEND  - Report Locks NOT Ended
      ********************************************************************
     C     RPTLCKSNEND   BEGSR
 
     C                   Z-ADD     1             R
     C     R             DOWLE     9999
     C     RcdD(R)       ANDNE     *BLANK
 
     C                   EVAL      JUN    = RcdJ(R)
     C                   EVAL      Record = RcdD(R)
 
      * If NOT ended
 
     C     JUN           LOOKUP    J2E                                    99
     C     *IN99         IFEQ      *OFF
 
      * Open print File
     C                   IF        WREPORT = 'Y'                                              CCB023
     C                   EXSR      OPNPRTF
 
      *  If file is on SCTRIGJ0
      *  or if file doesn't have a lock state of *SHRRD
      *    Highlight
     C                   EVAL      OBJECT    = %subst(Record:1 :10)
     C                   EVAL      LOCKSTATE = %subst(Record:57:10)
 
     C     SCTRIGK       CHAIN     SCTRIGJ0                           99
     C     *IN99         IFEQ      *OFF
     C     LOCKSTATE     ORNE      '*SHRRD'
     C                   MOVEL     '!!!'         LockNote
     C                   SETON                                        U7U8
     C                   ELSE
     C                   MOVEL     *BLANK        LockNote         10
     C                   ENDIF
      * Report
     C                   EXSR      PAGE_CHG_CHK
     C                   EXCEPT    LCKNENDD
     C                   ENDIF                                                                CCB023
 
     C                   ENDIF
 
     C                   ADD       1             R
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * FMT_CMD - Format Command
      *********************************************************************
     C     FMT_CMD       BEGSR
     C*******************MOVEA     BLK80         WQCmd(12)                                   BUG4846
     C**********         MOVEA     BLK44         WQCmd(12)                            BUG4846 240226
     C                   MOVEA     BLK30         WQCmd(12)                                    240226
     C                   MOVEA     JOBNUMBER     WQCmd(12)
     C                   Z-add     12            I                 3 0
     C     *BLANK        LOOKUP    WQCmd(I)                               99
     C                   MOVEA     '/'           WQCmd(I)
     C                   add       1             I
     C                   MOVEA     JOBUSER       WQCmd(I)
     C     *BLANK        LOOKUP    WQCmd(I)                               99
     C                   MOVEA     '/'           WQCmd(I)
     C                   add       1             I
     C                   MOVEA     JOBNAME       WQCmd(I)
     C     *BLANK        LOOKUP    WQCmd(I)                               99
     C                   MOVEA     ')'           WQCmd(I)
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      *********************************************************************
      * OPNPRTF - OPEN PRINTER FILE
      *********************************************************************
     C     OPNPRTF       BEGSR
     C     PrintOpen     IFNE      'Y'
     C                   MOVE      'Y'           PrintOpen         1
     C*******************SETON                                          U7U8                 BUG4846
     C                   SETON                                          U6                   BUG4846
     C                   Z-ADD     1             PageNumber        3 0
     C                   Z-ADD     4             LineNumber        3 0
     C                   OPEN      QSYSPRT
     C                   EXCEPT    HEADINGS
     C                   ENDIF
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * Page Change Check
      *****************************************************************
     C     PAGE_CHG_CHK  BEGSR
 
     C                   ADD       1             LineNumber
     C     LineNumber    IFGT      60
     C                   ADD       1             PageNumber
     C                   EXCEPT    HEADINGS
     C                   Z-ADD     4             LineNumber
     C                   ADD       1             LineNumber
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C**********         PARM                    Library          10                        MD021351
     C                   PARM                    WREPORT           1                          CCB023
 
     C     SCTRIGK       KLIST
     C                   KFLD                    OBJECT
 
      * Get System Prefix
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
 
     C                   MOVEL     *BLANK        WebUser          10
     C                   EVAL      WebUser = LIBR + 'WEBUSER'
 
     C*******************MOVEL     *BLANK        BLK80            80                         BUG4846
     C**********         MOVEL     *BLANK        BLK44            44                  BUG4846 240226
     C                   MOVEL     *BLANKS       BLK30            30                          240226
     C                   MOVEL     *BLANK        Record          100
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
     C                   IF        WREPORT = 'Y'                                              CCB023
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ELSE                                                                 CCB023
     C                   SETON                                        LR                      CCB023
     C                   ENDIF                                                                CCB023
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
     OQSYSPRT   E            HEADINGS       1 03
     O                                           14 'REF:SCKOBJLCOB'
     O                                           77 'KILL OBJECT LOCKS IN COB'
     O**********                                 89 ' FOR LIBRARY'                          MD021351
     O**********             Library            100                                         MD021351
     O                                          124 'PAGE:'
     O                       PageNumber    Z    128
     O          E            JOBENDD     1
     O                                           15 'Command issued:'
     O                       WCMD                96
     O          E            JOBNENDD    1
     O                                           19 'Command NOT issued:'
     O                       WCMD               100
     O          E            LCKENDD     1
     O                                           11 'Lock ended:'
     O                       Record             112
     O          E            LCKNENDD    1
     O                                           15 'Lock NOT ended:'
     O                       Record             116
     O                       LockNote           127
     O** WQcmd changed below: OPTION(*IMMED) added                                           BUG4846
**  WQcmd
ENDJOB JOB(                              OPTION(*IMMED)                                       240226

     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Set-up spool file numbers file')              *
      *****************************************************************
      *                                                               *
      *  Midas - Report Control Facility Module                       *
      *                                                               *
      *      ZSFILE - SET UP SPOOL FILE NUMBERS FILE                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  NOTE: This program is almost an exact duplicate of the pgm   *                       216350
      *        ZSFILE2 except that ZSFILE2 allows the reporting group *                       216350
      *        to be specified as a parameter. Therefore, any change  *                       216350
      *        to this program will probably also need to be applied  *                       216350
      *        to ZSFILE2 under the same change number.               *                       216350
      *                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1061934          Date 03Dec12               *
      *                 CCB020             Date 06Aug12               *
      *                 AR883675           Date 22Dec11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25288           Date 05Aug09               *
      *                 BUG24056           Date 20May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSC042             Date 16Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233791             Date 06Oct06               *
      *                 CFC003             Date 22Mar06               *
      *                 BUG5869            Date 21Mar05               *
      *                 TDA035             Date 02Apr04               *
      *                 CRE020             Date 20Jan04               *
      *                 212743             Date 28Nov02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 216350             Date 27Mar03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189818             Date 09Feb01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 142799             Date 14Feb99               *
      *                 CDE001             Date 18Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                     096301           Date 27Mar96             *
      *                     081261           Date 10Mar95             *
      *                     COR001           DATE 14FEB95             *
      *                     S01530           DATE 16JAN95             *
      *                     S01486           DATE 07JUN94             *
      *                     075899           DATE 20SEP94             *
      *                     S01382           DATE 23JUL92             *
      *                     E38368           DATE 10APR92             *
      *                     S01117           DATE 25MAR92             *
      *                     S01269           DATE 25JUN91             *
      *                     LN1183           DATE 27FEB91             *
      *                     LN1087           DATE 21DEC90             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  AR1061934 - encountered error in component REC3772 sequence  *
      *              00001                                            *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  AR883675 - Security Profile Facility reports                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25288 - Failed to show related batch items from GLJEIPPD  *
      *  BUG24056 - Error on SDC000790                                *
      *  CSC042 - COB performance fix. Stop the meaningless messages  *
      *           saying MAARCDPD has been changed to SEQONLY(*NO)    *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  233791 - Database error occurred for SD000766P etc           *
      *         - Change not applicable to ZSFILE2.                   *
      *  CFC003 - Use User department to print report on different    *
      *           printer when Report is System level                 *
      *           and Default output instruction ID is not blank      *
      *  BUG5869 - For archiving from outq, assign entity details as  *
      *            held by RCF; for archiving on request, report name *
      *            should include suffix.                             *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  212743 - Database error occurred for AS001003P               *
      *  216350 - A duplicate of ZSFILE (ZSFILE2) has been created    *
      *           with an extra parameter to define the reporting     *
      *           group when it differs from the logically calculated *
      *           one.                                                *
      *  189818 - Correct the CDE001 change to recognise the second   *
      *           array entry and extend the array to convert DL0411  *
      *           references to DL0410.                               *
      *  142799 - Add D6SFNO as one of the key fields for FCSFNOL0.   *
      *         - Check if level is company then write it to          *
      *           FCRREQPD to ensure proper distribution by RCF.      *
      *      CDE001 - Data Export - CCRM Limits                       *
      *      096301 - Correct output of distribution list for         *
      *               mandatory reports.                              *
      *      081261 - APPLY FIX 057517.                               *
      *               IF PHASE NOT COB OR NDSU, SET REPORT PRODUCED   *
      *               IN COB FLAG TO 'N', ELSE SOME REPORTS WHICH ARE *
      *               NOT REQUESTABLE GET WRITTEN TO FCRREQPD, CAUSING*
      *               DB ERROR 002 IN CB0105 WHEN NEXT COB STARTED    *
      *      COR001 - ORF Multibranching (Add entity, system level    *
      *               & name to optical disk headers)                 *
      *      S01530 - MAKE THE USER DATA FIELD OF THE SPOOL FILE      *
      *               CONTAIN THE BRANCH CODE OF THE REPORT.          *
      *      S01486 - Private Banking Upgrade to Rel 10.              *
      *               Add Account Officer and Department Level (RCF). *
      *      075899 - SET ON LR TO PREVENT THE COB LOCKING RCF FILES  *
      *               THAT RCF MONITOR IS TRYING TO CLEAR IN N.D.S.   *
      *      S01382 - OPTICAL DISK REPORTING                          *
      *               WRITE TO OPTICAL DISK HEADER RECORDS FILE IF    *
      *               OPTICAL DISK REQUESTED                          *
      *      E38368 - ACCESS TO MUSER SHOULDN'T BE CONDITIONED ON MBIN*
      *      S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD              *
      *      S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO     *
      *               MUSERDD                                         *
      *      LN1183 - (1) CORRECT THE SET UP OF LEVEL AND ENTITY      *
      *                   FIELDS FOR MANDATORY REPORTS                *
      *               (2) ADD COMMENTS TO THE PROGRAM                 *
      *               (3) REMOVE TOTALLY REDUNDANT CODE               *
      *      LN1087 - REMOVE REPORT SUFFIX FROM KEY LIST TO           *
      *               READ THE PERMANAENT ARCHIVE FILE MAARCPL2       *
      *               THIS WILL THEN ALLOW WRITE TO ARCHIVE           *
      *               DETAILS FILE MAARCDPD                           *
      *                                                               *
      *****************************************************************
     FFCRREQL0  UF A E           K DISK
     F*FCRSFXL1* IF   E           K DISK                                                    MD055265
     F*FCREPTL1* IF   E           K DISK                                                    MD055265
     FMAARCPL2  IF   E           K DISK
     FFCMOUTL1  IF   E           K DISK
     FMUSER     IF   E           K DISK
     FFCSFNOL0  UF A E           K DISK
     F***MAARCDPDO   E                    DISK                                                CSC042
     FMAARCDPD  O    E             DISK    USROPN
     F****************************************************************
     F*         FUNCTION OF INDICATORS
     F*
     F****01****FIRST CYCLE
     F*   30    CHAIN FAIL TO MANDATORY OUTPUT INSTRUCTIONS
     F*   31    CHAIN FAIL TO MUSER
     F*   32    CHAIN FAIL TO REPORT REQUESTS
     F*   33    END OF RECORDS ON ARCHIVE CONTENTS PERM FOR REPORT
     F****34****CHAIN*FAIL*TO*REPORT*DESCRIPTIONS                         LN1183
     F*   35    CHAIN FAIL TO SPOOL FILE NUMBERS
     F*                                                                   LN1183
     F*   LR,U7&U8 SET ON IN EVENT OF DATABASE ERROR                      LN1183
     F*                                                                   LN1183
     F****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D**********          PRT@    1   2 10                                             CDE001 189818
     D**********          PGM@    1   2 10                                             CDE001 189818
     D**********          PRT@    1   5 10                                                    212743
     D**********          PGM@    1   5 10                                                    212743
     D**********          PRT@    1  19 10                                             212743 CRE020
     D**********          PGM@    1  19 10                                             212743 CRE020
     D**********          PRT@    1  34 10                                             CRE020 233791
     D**********          PGM@    1  34 10                                             CRE020 233791
     D**********          PRT@    1  60 10                                           233791 BUG24056
     D**********          PGM@    1  60 10                                           233791 BUG24056
     D**********          PRT@    1  62 10                                         BUG24056 BUG25288
     D**********          PGM@    1  62 10                                         BUG24056 BUG25288
     D**********          PRT@    1  65 10                                         BUG25288 AR883675
     D**********          PGM@    1  65 10                                         BUG25288 AR883675
     D**********          PRT@    1  77 10                                        AR883675 AR1061934
     D**********          PGM@    1  71 10                                        AR883675 AR1061934
     D PRT@            S             10    DIM(80) CTDATA PERRCD(1)
     D PGM@            S             10    DIM(80) CTDATA PERRCD(1)
     D #CMD            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D RSFXDS          DS
     D*
     D** DATASTRUCTURE FOR REPORT SUFFIX CHAIN FAIL
     D*
     D  D5RNAM                 1     10
     D  SFNAME                11     20
     D*
     D LDA             DS           256
     D*
     D** LOCAL DATA AREA FOR DATABASE ERROR STORE
     D*
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D*
     D REPSEQ          DS
     D*
     D** REPORT SEQUENCE NUMBER
     D*
     D  SEQ                    1      5  0
     D*
     D RUNDAT          DS
     D*
      ** DATA AREA OF BANK DETAILS
     D*
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
     D*
     D**MPHAS*******DS                                                                        CCB020
     D*
     D***PHASE*OF*DAY                                                                         CCB020
     D*
     D**********                              1   1 PHASE                                     CCB020
     D*                                                                   S01382
     D** Parameter list to pass to write to optical disk header record    S01382
     D*                                                                   S01382
     D IHEAD           DS                                                       S01382
     D  HEADER                 1    198                                         S01382
     D  OUTPUT                 1      4                                         S01382
     D  REPORT                 5     14                                         S01382
     D  USERID                15     24                                         S01382
     D  JOBNAM                25     34                                         S01382
     D  JOBNBR                35     40                                         S01382
     D  SPLFNO                41     44                                         S01382
     D  RPTLVL                45     45                                         S01382
     D  ENTITY                46     48                                         S01382
     D  RSEQNO                49     53                                         S01382
     D  PRTFNM                54     63                                         S01382
     D*
     D*
     D PSDS           SDS
     D*
     D** PROGRAM STATUS DATA STRUCTURE FOR USER ETC.
     D*
     D  JBNM                 244    253
     D  JUSR                 254    263
     D  JBNB                 264    269
     D*
     D SPOOLN          DS
     D*
     D** SPOOL FILE NUMBER CONVERSION TO ALPHA
     D*
     D  SFNOS                  1      6  0
     D*
     D RCFICD        E DS                  EXTNAME(SDRCFPD)                     S01530
     D FCREPT        E DS                  EXTNAME(FCREPJW0)                                MD055265
     D FCRSFX        E DS                  EXTNAME(FCRSFJW0)                                MD055265
      *                                                                   S01530
     C     CSC042        IFNE      'Y'
     C                   MOVEA     CPY@          BIS@             80
     C                   MOVEL     'Y'           CSC042            1
     C                   CALL      'QCMDEXC'
     C                   PARM      #CMD(1)       PARM1            80
     C                   PARM      80            PARM2            15 5
     C                   OPEN      MAARCDPD
     C                   END
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
      *
      ** Accept Parameters
      *
     C     *ENTRY        PLIST
     C     RQSQ          PARM                    RSQNCE            5
     C                   PARM                    ETTY
     C     SFNAME        PARM                    SFN              10
     C                   PARM                    SFNOP             6 0
     C                   PARM                    ERR               1
      *
     C***********RREQ      KLIST                                          LN1183
     C***********          KFLD           RQSQ                            LN1183
      *
      ** Define Key List for chain to Permanent Archive Contents File     LN1183
      *                                                                   LN1183
     C     ARCP          KLIST
     C                   KFLD                    D5RNAM
     C                   KFLD                    PSQN
     C***********          KFLD           RSFX                            LN1087
      *
     C     *LIKE         DEFINE    D5RQSQ        RQSQ
     C     *LIKE         DEFINE    ECPSQN        PSQN
     C     *LIKE         DEFINE    ECRSFX        RSFX
     C     *LIKE         DEFINE    D5ETTY        ETTY
     C     *LIKE         DEFINE    D6SFNO        SFNO
      *
      ** Convert spool file number to 4 alpha
      *
     C                   Z-ADD     SFNOP         SFNOS
     C                   MOVE      SFNOS         SFNO
     C                   MOVE      ERR           LEVEL             1                           14279
      *                                                                                       189818
      * Initialise FCKEY with SFNAME value                                                    189818
      *                                                                                       189818
     C                   MOVE      SFNAME        FCKEY            10
     C                   MOVEL     SFNAME        S_NAME           10                        MD055265
      ******
      ****F*first*call*****
      ******
     C******     *IN01     IFEQ '0'
     C******               EXSR FIRST
     C******               END
      *                                                                   S01530
      ** Check what value should be recorded in the user data             S01530
      *                                                                   S01530
     C                   MOVEL     '*FIRST'      P@OPTN            7                           S0153
      *                                                                   S01530
     C                   CALL      'AORCFR0'                                                   S0153
     C                   PARM                    P@RTCD            7            B:Return code  S0153
     C                   PARM                    P@OPTN                         I:Option       S0153
     C                   PARM                    RCFICD                         O:Format       S0153
      *                                                                   S01530
      ** Check return code                                                S01530
     C     P@RTCD        IFNE      *BLANK                                                      S0153
     C     *LOCK         IN        LDA                                                         S0153
     C                   MOVEL     *BLANKS       DBKEY                          ***************S0153
     C                   MOVEL     'SDRCFL0 '    DBFILE                         * DB ERR  005 *S0153
     C                   Z-ADD     5             DBASE                          ***************S0153
     C                   MOVEL     'ZSFILE'      DBPGM                                         S0153
     C                   OUT       LDA                                                         S0153
     C                   EXSR      DBERR                                                       S0153
     C                   END                                                                   S0153
      *
     C                   MOVEL     S_NAME        SFNAME                                     MD055265
      ***Update*report*requests*file                                      LN1183
      ** Update or write to report requests file                          LN1183
     C                   EXSR      REPRQU
      *
      ** Update*spool*files*numbers*file                                  LN1183
      ** Update or write to spool files numbers file                      LN1183
     C                   EXSR      REST
      *                                                                   S01382
      ** Write header records to optical disk header file                 S01382
     C                   EXSR      ODHDR                                                       S0138
     C                   SETON                                        LR                       07589
      *
     C                   RETURN
      ********************************************************************
      /EJECT
      ********************************************************************
      ***S/R*FIRST*-*PERFORM UPDATE/WRITE OF REPORT REQUEST
      ***************RECORD ON FIRST CALL
      ** S/R REPRQU- PERFORM UPDATE/WRITE OF REPORT REQUEST
      ** CALLED FROM MAIN PROCESSING
      ***CALLS*DBASE                                                      LN1183
      ** Calls Subroutine DBERR                                           LN1183
      ********************************************************************
      *
     C***********FIRST     BEGSR
     C     REPRQU        BEGSR
      *
     C************         SETON                     01
      *
      ********IF*sequence*is*blank:*mandatory*report                      LN1183
      ** If sequence number is blank then a                               LN1183
      ** mandatory report is being processed                              LN1183
      *
     C     RQSQ          IFEQ      *BLANK
      *
      *************Receive*Data*area*REPSEQ*for*next*sequence*number***   LN1183
      *************Update*Data*area*REPSEQ*to*one*greater*than*input*numbeLN1183
      ** Obtain next sequence number from data area REPSEQ                LN1183
      ** and update data area for next request                            LN1183
      *
     C     *DTAARA       DEFINE                  REPSEQ
     C     *LOCK         IN        REPSEQ
     C                   MOVE      SEQ           RQSQ
     C                   ADD       1             SEQ
     C                   OUT       REPSEQ
     C***************      MOVE SEQ       RSQNCE
      *
      ** return sequence number used to calling pgm
     C                   MOVE      RQSQ          RSQNCE
      *
      **           Receive Data area RUNDAT for multibranching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      *************Receive*Data*area*MPHAS*for*phase*of*day************                       CCB020
      *
     C********** *NAMVAR   DEFN           MPHAS                                               CCB020
     C**********           IN   MPHAS                                                         CCB020
      *                                                                                       CCB020
      ** CBFLAGQT Phase Check                                                                 CCB020
      *                                                                                       CCB020
     C                   MOVEL     'CBC00100'    @CBPRM            9
     C                   MOVE      '1'           @CBPRM
     C                   CALL      @CBPRM
     C                   PARM      *BLANKS       CBFLG             4
      *
      ***IF*PHASE*OF*DAY*IS*COB/NEXT*DAY*SETUP*SET*REPORT                 LN1183
      ***PRODUCTION*TO*COB,*OTHERWISE*INPUT*CYCLE********                 LN1183
      ***If*the*phase*of*day*is*Close*of*Business*or*Next*Day*Set*Up,**                LN1183 CCB020
      ***set*Report*Produced*in*COB*flag*to*'Y',*otherwise*set*********                LN1183 CCB020
      ***Report*Produced*in*Input*Cycle*flag*to*'Y'********************                LN1183 CCB020
      *
     C*********  PHASE     IFEQ 'C'                                                           CCB020
     C*********  PHASE     OREQ 'D'                                                           CCB020
     C*********  PHASE     OREQ 'E'                                       081261
     C     CBFLG         IFEQ      '*YES'
     C                   MOVE      'Y'           D5COBR
     C                   MOVE      'N'           D5IPCY
     C                   ELSE
     C                   MOVE      'Y'           D5IPCY
     C                   MOVE      'N'           D5COBR
     C                   END
      *
     C                   MOVE      'N'           D5PDFL
      *
      **           Access Report Descriptions using
      **            spool file name to set limits
      *
      ** Where printer files names not program name + suffix              CDE001
      *                                                                   CDE001
     C                   Z-ADD     1             I                 2 0                         CDE00
     C     SFNAME        LOOKUP    PRT@(I)                                32                   CDE00
     C     *IN32         IFEQ      *ON                                                         CDE00
     C                   MOVEA     PGM@(I)       FCKEY
     C********** PGM@,I    CHAINFCREPTL1             32                                CDE001 189818
     C*****FCKEY         CHAIN     FCREPTL1                           32                    MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT                                                                        MD055265
     C+ from FCREPJW0                                                                       MD055265
     C+ where DXRNAM = :FCKEY                                                               MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       32                    MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                        32                    MD055265
     C                   ENDIF                                                              MD055265
     C                   ELSE                                                                  CDE00
      *                                                                   CDE001
      ** Where printer files names are program name + suffix              CDE001
      *                                                                   CDE001
     C*****SFNAME        SETLL     FCREPTL1                                                 MD055265
      *                                                                   LN1183
      ** Read previous record to the one to which the pointer is set,     LN1183
      ** as Report Descriptions File is keyed on Report name              LN1183
      ** and key used for SETLL is the printer file name                  LN1183
      *                                                                   LN1183
     C**********         READP     FCREPTL1                               32                MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT                                                                        MD055265
     C+ from FCREPJW0                                                                       MD055265
     C+ where DXRNAM < :sfname                                                              MD055265
     C+ order by DXRNAM desc                                                                MD055265
     C/END-EXEC                                                                             MD055265
     C                   IF        SQLCODE = 0                                              MD055265
     C                             or SQLCODE = -811                                        MD055265
     C                   SETOFF                                       32                    MD055265
     C                   ELSE                                                               MD055265
     C                   SETON                                        32                    MD055265
     C                   ENDIF                                                              MD055265
      *
     C                   ENDIF                                                                 CDE00
      *                                                                   CDE001
      ***Check*first*6*characters*of*retrieved*rec*match*spool*file*name  LN1183
      ** If a record is found determine whether the first six             LN1183
      ** characters of the report name match the first six                LN1183
      ** characters of the spool file name                                LN1183
      *
     C     *IN32         IFEQ      '0'
     C                   MOVEL     DXRNAM        REPTR             6
     C                   MOVEL     SFNAME        SFNMR             6
     C     REPTR         COMP      SFNMR                              3232
     C                   END
      *
      *************IF*no*matching*record*found*attempt*chain******        LN1183
      **************as*Midas/Q*report*name*will*be*print*file*name        LN1183
      ** If no matching record is found, attempt chain                    LN1183
      ** with the spool file name, as this may be a Midas/Q               LN1183
      ** report for which the print file name will be the                 LN1183
      ** same as the Report Name                                          LN1183
      *
     C     *IN32         IFEQ      '1'
     C********** SFNAME    CHAINFCREPTL1             32                                       189818
     C*****FCKEY         CHAIN     FCREPTL1                           32                    MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT                                                                        MD055265
     C+ from FCREPJW0                                                                       MD055265
     C+ where DXRNAM = :FCKEY                                                               MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       32                    MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                        32                    MD055265
     C                   ENDIF                                                              MD055265
     C                   END
      *
      **           IF no matching record found,
      **                Database error
      *
     C     *IN32         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     SFNMR         DBKEY                          ***************
     C                   MOVEL     'FCREPTL0'    DBFILE                         * DB ERR  003 *
     C                   Z-ADD     3             DBASE                          ***************
     C                   MOVEL     'ZSFILE'      DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
      ** Access the Mandatory Output Instructions File to determine       LN1183
      ** if there are Mandatory Output Instructions for this report       LN1183
      *                                                                   LN1183
     C                   MOVE      *BLANKS       D2DLS1                                        09630
     C                   MOVE      *BLANKS       D2DLS2                                        09630
     C                   MOVE      *BLANKS       D2USRO                                        09630
     C                   MOVE      *BLANKS       D2ARMF                                        09630
     C                   MOVE      *BLANKS       D2AROD                                        09630
     C*                                                                   096301
     C     DXRNAM        CHAIN     FCMOUTL1                           30
      *
      *************IF*no**ecord*found*************                        LN1183
      ******************Set*Midas*User*Id*to*Midas                        LN1183
      *************ELSE***************************                        LN1183
      ******************Set*user*Id*to*that*from*Mandatory*inst.          LN1183
      *                                                                   LN1183
      ** If a record is found then set User Id, Output Inst and           LN1183
      ** Distribution Required as defined on the record                   LN1183
      **                                                                  LN1183
      ** Else                                                             LN1183
      ** Set the default values for these fields:-                        LN1183
      ** Set User Id to be MIDAS, then determine default output Id        LN1183
      ** and whether distribution is required.                            LN1183
      *
     C     *IN30         IFEQ      '0'
     C                   MOVE      D2DFTU        D5USRR
     C                   MOVE      D2DFTO        D5SOID
     C                   MOVE      D2DRQD        D5DRQD
     C                   ELSE
     C                   MOVE      *BLANKS       D5USRR
     C                   MOVEL     'MIDAS'       D5USRR
      *                                                                                       CFC003
     C     CFC003        IFEQ      'Y'
     C                   MOVEL     JUSR          D5USRR
     C                   ENDIF
      *
      ** SET UP DEFAULT OUTPUT ID: FROM REPORT DESCRIPTION IF AVAILABLE
      ** OTHERWISE, SET TO 'MIDAS'
      *
     C     DXDFTO        IFNE      *BLANK
     C                   MOVE      DXDFTO        D5SOID
     C                   ELSE
     C                   MOVEL     'MIDAS'       D5SOID
     C                   END
      *
      ***IF*MULTIBRANCHING*SYSTEM,*SET*DISTRIBUTION*FOR*REPORT*REQUEST*   S01486
      ***OTHERWISE*BLANK*OUT*THE*FIELD,*AS*IT*IS*NOT*USED.*************   S01486
      *
      ** Set distribution for report request regardless of                S01486
      ** whether multibranching is on or not.                             S01486
     C***********MBIN      IFEQ 'Y'                                       S01486
      *
      ** IF ENTITY IS BLANK, REPORT SET TO SYSTEM LEVEL, SO SET
      ** DISTRIBUTION TO 'N', ELSE SET TO YES
      *
     C     ETTY          IFEQ      *BLANK
     C                   MOVE      'N'           D5DRQD
     C                   ELSE
     C                   MOVE      'Y'           D5DRQD
     C                   END
      *
     C***********          ELSE                                           S01486
     C***********          MOVE *BLANK    D5DRQD                          S01486
     C***********          END                                            S01486
      *
     C                   END
      *
      *************IF*Multibranch*system                                  LN1183
      ** If in a Multibranch system, then set the                         LN1183
      ** Default Branch for the requesting User                           LN1183
      *
     C********** MBIN      IFEQ 'Y'                                      E38368
      *
      **                Access MUSER for Default Branch of user
      *
     C     D5USRR        CHAIN     MUSER                              31
      *
      **                IF no record found,
      **                     Database error
      *
     C     *IN31         IFEQ      '1'
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     D5USRR        DBKEY                          ***************
     C                   MOVEL     'MUSER'       DBFILE                         * DB ERR  001 *
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'ZSFILE'      DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
     C**********           END                                           E38368
      *
      *************Write*to*report*requests*file                          LN1183
      ** For all mandatory report requests,                               LN1183
      ** set up fields to write to report requests file                   LN1183
      *
     C                   MOVEL     DXRNAM        D5RNAM
     C                   MOVE      RQSQ          D5RQSQ
     C                   MOVE      DBRN          D5DBRN
     C                   MOVE      D2DLS1        D5DLS1
     C                   MOVE      D2DLS2        D5DLS2
     C                   MOVE      D2USRO        D5USRO
     C                   MOVE      D2ARMF        D5ARMF
     C                   MOVE      D2AROD        D5AROD
     C                   MOVEL     JUSR          D5JUSR
     C                   MOVEL     JBNM          D5JBNM
     C                   MOVE      JBNB          D5JBNB
      *
      ** In a Multi-branched system set up the level and entity fields    LN1183
      ** to be the same for Single Branch environment.                    S01486
      *                                                                   LN1183
     C***********MBIN      IFEQ 'Y'                                       S01486
     C***********ETTY      ANDEQ*BLANK                                    LN1183
     C     ETTY          IFEQ      *BLANK                                                      LN118
     C                   MOVE      *BLANKS       D5ETTY                                        LN118
     C                   MOVE      'S'           D5LVL
     C                   END
      *
     C     ETTY          IFNE      *BLANK
     C                   MOVE      'ALL'         D5ETTY
      *
      ** If Multibranching is on and Account Officer Level is not         S01486
      ** available then the Report level is 'B'; Else 'A'.                S01486
     C     MBIN          IFEQ      'Y'                                                         S0148
      *                                                                   S01486
     C     DXALVL        IFEQ      'Y'                                                         S0148
     C                   MOVE      'A'           D5LVL                                         S0148
     C                   ELSE                                                                  S0148
     C                   MOVE      'B'           D5LVL
     C                   END
      *                                                                   S01486
     C                   ELSE                                                                  S0148
     C                   MOVE      'A'           D5LVL                                         S0148
     C                   END                                                                   S0148
      *
     C                   END                                                                   LN118
      *                                                                   LN1183
      ** In a Single branch system ensure that the                        LN1183
      ** level and entity fields are blank                                LN1183
      *                                                                   LN1183
     C     MBIN          IFEQ      'N'                                                         LN118
     C                   MOVE      *BLANKS       D5ETTY                                        LN118
     C                   MOVE      *BLANKS       D5LVL                                         LN118
     C                   END                                                                   LN118
      *                                                                   142799
      ** Check if company level is specified                              142799
      *                                                                   142799
     C     LEVEL         IFEQ      'C'                                                         14279
     C                   MOVE      'ALL'         D5ETTY                                        14279
     C                   MOVE      'C'           D5LVL                                         14279
     C                   END                                                                   14279
      *                                                                   LN1183
      ** Write record to file                                             LN1183
      *                                                                   LN1183
     C                   WRITE     @D5REI8
      *
      *************IF*Archiving*has*been*requested******************      LN1183
      ******************Access*archive*Contents*permanent*for*report      LN1183
      ** If Archiving has been requested, access the                      LN1183
      ** archive contents permanent file for the report details           LN1183
      *
     C     D2ARMF        IFEQ      'Y'
     C     D2AROD        OREQ      'Y'
     C                   MOVE      '00'          PSQN
     C     ARCP          SETLL     MAARCPL2
     C     ARCP          READE     MAARCPL2                               33
      *
      ******************DOWHILE*Records*exist*for*the*report              LN1183
      ***********************Write*to*Archive*Contents*Daily              LN1183
      ***********************Read*next*archive*contents*Perm*record       LN1183
      ******************ENDDO                                             LN1183
      * For each record which exists for the report,                      LN1183
      * write a record to the Daily Archive Contents File                 LN1183
      *
     C     *IN33         DOWEQ     '0'
     C                   MOVE      D5RNAM        EBRNAM
     C                   MOVE      D5RQSQ        EBRQSQ
     C                   MOVE      ECARID        EBARID
     C                   MOVE      ECRSFX        EBRSFX
     C                   MOVE      'N'           EBCFLG
     C                   MOVE      'N'           EBACFL
     C                   WRITE     MAARCDD0
     C     ARCP          READE     MAARCPL2                               33
     C                   END
      *
     C                   END
      *
      ********ELSE:*Requested*report*****                                 LN1183
      ** Else if the sequence number is not blank, then a                 LN1183
      ** requested report is being processed                              LN1183
      *
     C                   ELSE
      *
      *************Access*Report*Requests                                 LN1183
      ** Access the Report Requests file                                  LN1183
      *
     C     RQSQ          CHAIN     FCRREQL0                           32
      *
      **           IF no record found
      **                Database error
      *
     C     *IN32         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     RQSQ          DBKEY                          ***************
     C                   MOVEL     'FCRREQL0'    DBFILE                         * DB ERR  004 *
     C                   Z-ADD     4             DBASE                          ***************
     C                   MOVEL     'ZSFILE'      DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
      *************Update*report*requests                                 LN1183
      ** Update the report requests record with the job details           LN1183
      *
     C                   MOVEL     JUSR          D5JUSR
     C                   MOVEL     JBNM          D5JBNM
     C                   MOVEL     JBNB          D5JBNB
     C                   UPDATE    @D5REI8
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      ** S/R REST - PERFORM WRITE TO SPOOL FILE NUMBERS
      ** CALLED FROM MAIN PROCESSING
      ***CALLS*NO*OTHER*SUBROUTINES                                       LN1183
      ** Calls Subroutine DBERR                                           LN1183
      ********************************************************************
      *
     C     REST          BEGSR
      *
      ***Write*to*spool*file*nos.                                         LN1183
      ** Set up sequence number, print file name and entity               LN1183
      ** for the write of a record to the spool file numbers file         LN1183
      ** or chain to the spool file numbers file if this is a restart     LN1183
      *
     C                   MOVE      RQSQ          D6RQSQ
     C                   MOVEL     SFNAME        D6RSFX
     C                   MOVE      ETTY          D6XETY
      *
      ** Access spool file numbers file for the current details in case
      ** of re-start
      *
     C     SFNOKY        KLIST
     C                   KFLD                    D6RQSQ
     C                   KFLD                    D6RSFX
     C                   KFLD                    D6XETY
     C                   KFLD                    D6SFNO                                        14279
      *                                                                   142799
     C                   MOVE      SFNO          D6SFNO                                        14279
      *
     C     SFNOKY        CHAIN     FCSFNOL0                           35
      *
      ** Set up spool file number and status for the write to or          LN1183
      ** update of a record on the spool file numbers file                LN1183
      *                                                                   LN1183
     C***********          MOVE SFNO      D6SFNO                          142799
     C                   MOVE      'N'           D6PSTS
      *
      ** If a record was found on the spool file numbers file             LN1183
      ** then update the file                                             LN1183
      ** Else write a new record to the file                              LN1183
      *                                                                   LN1183
     C     *IN35         IFEQ      '0'
     C                   UPDATE    @D6REJB
     C                   ELSE
     C*
     C***Access*report*suffixes*for*audit*file*flag                       LN1183
     C** Access the report print file name file                           LN1183
     C** for the value of the audit file flag                             LN1183
     C*
     C     RSFXK         KLIST
     C                   KFLD                    D5RNAM
     C                   KFLD                    SFNAME
     C*****RSFXK         CHAIN     FCRSFXL1                           33                    MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRSFX                                                                        MD055265
     C+ from FCRSFJW0                                                                       MD055265
     C+ where DYRNAM = :D5RNAM and DYRSFX = :SFNAME                                         MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                         33                  MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                          33                  MD055265
     C                   ENDIF                                                              MD055265
                                                                                            MD055265
      *
      **           IF no record found
      **                Database error
      *
     C     *IN33         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     RSFXDS        DBKEY                          ***************
     C                   MOVEL     'FCRSFXL0'    DBFILE                         * DB ERR  002 *
     C                   Z-ADD     2             DBASE                          ***************
     C                   MOVEL     'ZSFILE'      DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
     C                   MOVE      DYAURP        D6AURP
     C                   WRITE     @D6REJB
     C                   END
      *
      ** Update user data with the entity.                                S01530
     C                   EXSR      UDATA                                                       S0153
      *                                                                   S01530
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************S01382
      ** S/R ODHDR - WRITE RECORDS TO OPTICAL DISK HEADER RECORDS FILE    S01382
      ** CALLED FROM MAIN PROCESSING                                      S01382
      ** CALLS MA0640 - CREATE HEADER RECORDS FOR OPTICAL DISK PROCESSING S01382
      ********************************************************************S01382
      *                                                                   S01382
     C     ODHDR         BEGSR                                                                 S0138
      *                                                                   S01382
      ** Write header records to optical disk header file if optical      S01382
      ** disk is requested.                                               S01382
      *                                                                   S01382
     C     D5AROD        IFEQ      'Y'                                                         S0138
     C                   MOVE      *BLANKS       HEADER                                        S0138
     C                   MOVE      *BLANKS       @ERROR            1                           S0138
     C                   MOVE      'OHDR'        OUTPUT                                        S0138
     C**********           MOVE D5RNAM    REPORT                                      S01382 BUG5869
     C                   MOVEL     D6RSFX        REPORT
      *                                                                   S01382
     C     D5USRO        IFEQ      *BLANKS                                                     S0138
     C                   MOVE      D5JUSR        USERID                                        S0138
     C                   ELSE                                                                  S0138
     C                   MOVE      D5USRO        USERID                                        S0138
     C                   END                                                                   S0138
      *                                                                   S01382
     C                   MOVE      D5JBNM        JOBNAM                                        S0138
     C                   MOVE      D5JBNB        JOBNBR                                        S0138
     C                   MOVE      SFNO          SPLFNO                                        S0138
     C                   MOVE      D5LVL         RPTLVL                                        S0138
     C***********          MOVE D5ETTY    ENTITY                   S01382 COR001
     C                   MOVE      D6XETY        ENTITY                                        COR00
     C                   MOVE      D5RQSQ        RSEQNO                                        S0138
     C                   MOVEL     D6RSFX        PRTFNM                                        S0138
     C                   CALL      'MA0640'                                                    S0138
     C                   PARM                    HEADER                                        S0138
     C                   PARM                    @ERROR                                        S0138
      *                                                                   S01382
     C     @ERROR        IFEQ      'Y'                                                         S0138
     C                   EXSR      *PSSR                                                       S0138
     C                   END                                                                   S0138
      *                                                                   S01382
     C                   END                                                                   S0138
      *                                                                   S01382
     C                   ENDSR                                                                 S0138
      *                                                                   S01382
      ********************************************************************S01382
      /EJECT
     C********************************************************************
     C*
     C*  S/R DBERR - TO PROCESS DATABASE ERRORS AND TERMINATE PROGRAM
     C***CALLED*FROM*REPORT                                               LN1183
     C*  Called from subroutines - REPRQU                                 LN1183
     C*                          - REST                                   LN1183
     C*  Calls subroutine - *PSSR                                         LN1183
     C*
     C********************************************************************
     C*
     C     DBERR         BEGSR
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   RETURN
     C                   ENDSR
     C********************************************************************
      /EJECT                                                              S01530
      *****************************************************************   S01530
      *                                                               *   S01530
      *  S/R UDATA - UPDATE USER DATA                                 *   S01530
      *  CALLED FROM                                                  *   S01530
      *                                                               *   S01530
      *****************************************************************   S01530
     C     UDATA         BEGSR                                                                 S0153
      *                                                                   S01530
     C     D0UDTA        IFNE      *BLANK                                                      S0153
     C     D0UDTA        ANDNE     'R'                                                         S0153
      *                                                                   S01530
      ** Initialise user data field                                       S01530
     C                   MOVE      *BLANK        USRDTA           10                           S0153
      *                                                                   S01530
      ** If entity is to be recorded in the user data                     S01530
     C     D0UDTA        IFEQ      'E'                                                         S0153
     C                   MOVEL     ETTY          USRDTA                                        S0153
     C     USRDTA        IFEQ      *BLANK                                                      S0153
     C                   MOVEL     'SYSTEM'      USRDTA                                        S0153
     C                   END                                                                   S0153
     C                   END                                                                   S0153
      *                                                                   S01530
      ** Call FCC0320 to update the user data                             S01530
     C                   CALL      'FCC0320'                                                   S0153
     C                   PARM                    SFN                                           S0153
     C                   PARM                    USRDTA                                        S0153
     C                   PARM                    BERR              1                           S0153
      *                                                                   S01530
      ** Error during FC0320 processing, run PSSR.                        S01530
     C     BERR          IFEQ      'Y'                                                         S0153
     C                   SETON                                        U7U8LR                   S0153
     C                   EXSR      *PSSR                                                       S0153
     C                   RETURN                                                                S0153
     C                   END                                                                   S0153
      *                                                                   S01530
     C                   END                                                                   S0153
      *                                                                   S01530
     C                   ENDSR                                                                 S0153
      ****************************************************************    S01530
      /EJECT
     C********************************************************************
     C*
     C*  S/R *PSSR - ERROR ROUTINE
     C*  CALLED FROM DBERR
     C*
     C********************************************************************
     C*
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   MOVE      'Y'           ERR
     C                   DUMP
     C                   END
     C                   ENDSR
     C********************************************************************
** CPY@
(c) Finastra International Limited 2001
** PRT@
DEREPTDP1                                                                                     189818
DEREPTSP1                                                                                     189818
DL0411AU                                                                                      189818
DL0411P1                                                                                      189818
DL0411P2                                                                                      189818
SD000742AU                                                                                    212743
SD000742P1                                                                                    212743
SD000743AU                                                                                    212743
SD000743P1                                                                                    212743
AS000001AU                                                                                    212743
AS000001P1                                                                                    212743
AS001003AU                                                                                    212743
AS001003P1                                                                                    212743
AS001003P2                                                                                    212743
AS001005AU                                                                                    212743
AS001005P1                                                                                    212743
AS001009AU                                                                                    212743
AS001009P1                                                                                    212743
AS001009P2                                                                                    212743
RE000881AU                                                                                    CRE020
RE000881P1                                                                                    CRE020
RE000881AU                                                                                    CRE020
RE000881P1                                                                                    CRE020
RE000881AU                                                                                    CRE020
RE000881P1                                                                                    CRE020
RE000881AU                                                                                    CRE020
RE000881P1                                                                                    CRE020
RE000881AU                                                                                    CRE020
RE000881P1                                                                                    CRE020
RE000881AU                                                                                    CRE020
RE000881P1                                                                                    CRE020
RE000881AU                                                                                    CRE020
RE000881P1                                                                                    CRE020
RE000080AU                                                                                    CRE020
SD000761AU                                                                                    233791
SD000761P1                                                                                    233791
SD000762AU                                                                                    233791
SD000762P1                                                                                    233791
SD000763AU                                                                                    233791
SD000763P1                                                                                    233791
SD000764AU                                                                                    233791
SD000764P1                                                                                    233791
SD000765AU                                                                                    233791
SD000765P1                                                                                    233791
SD000766AU                                                                                    233791
SD000766P1                                                                                    233791
SD000767AU                                                                                    233791
SD000767P1                                                                                    233791
SD000768AU                                                                                    233791
SD000768P1                                                                                    233791
SD000769AU                                                                                    233791
SD000769P1                                                                                    233791
SD000770AU                                                                                    233791
SD000770P1                                                                                    233791
SD000771AU                                                                                    233791
SD000771P1                                                                                    233791
SD000772AU                                                                                    233791
SD000772P1                                                                                    233791
SD000780AU                                                                                    233791
SD000780P1                                                                                    233791
SD000790AU                                                                                  BUG24056
SD000790P1                                                                                  BUG24056
GL001600AU                                                                                  BUG25288
GL001600P1                                                                                  BUG25288
GL0150P1                                                                                    BUG25288
GP004001P1                                                                                  AR883675
GP004001AU                                                                                  AR883675
GP004002P1                                                                                  AR883675
GP004002AU                                                                                  AR883675
GP004003P1                                                                                  AR883675
GP004003AU                                                                                  AR883675
GP004004P1                                                                                  AR883675
GP004004AU                                                                                  AR883675
GP004005P1                                                                                  AR883675
GP004005AU                                                                                  AR883675
GP004006P1                                                                                  AR883675
GP004006AU                                                                                  AR883675
RE3772P2                                                                                   AR1061934
RE3772P1                                                                                   AR1061934
RE3772AU                                                                                   AR1061934
** PGM@
DEREPTRND                                                                                     189818
DEREPTRNS                                                                                     189818
DL0410                                                                                        189818
DL0410                                                                                        189818
DL0410                                                                                        189818
SD000742                                                                                      212743
SD000742                                                                                      212743
SD000743P                                                                                     212743
SD000743P                                                                                     212743
AS000001P                                                                                     212743
AS000001P                                                                                     212743
AS001003P                                                                                     212743
AS001003P                                                                                     212743
AS001003P                                                                                     212743
AS001005                                                                                      212743
AS001005                                                                                      212743
AS001009                                                                                      212743
AS001009                                                                                      212743
AS001009                                                                                      212743
RE000882                                                                                      CRE020
RE000882                                                                                      CRE020
RE000883                                                                                      CRE020
RE000883                                                                                      CRE020
RE000884                                                                                      CRE020
RE000884                                                                                      CRE020
RE000885                                                                                      CRE020
RE000885                                                                                      CRE020
RE000886                                                                                      CRE020
RE000886                                                                                      CRE020
RE000887                                                                                      CRE020
RE000887                                                                                      CRE020
RE000888                                                                                      CRE020
RE000888                                                                                      CRE020
RE000080                                                                                      CRE020
SD000761P                                                                                     233791
SD000761P                                                                                     233791
SD000762P                                                                                     233791
SD000762P                                                                                     233791
SD000763P                                                                                     233791
SD000763P                                                                                     233791
SD000764P                                                                                     233791
SD000764P                                                                                     233791
SD000765P                                                                                     233791
SD000765P                                                                                     233791
SD000766P                                                                                     233791
SD000766P                                                                                     233791
SD000767P                                                                                     233791
SD000767P                                                                                     233791
SD000768P                                                                                     233791
SD000768P                                                                                     233791
SD000769P                                                                                     233791
SD000769P                                                                                     233791
SD000770P                                                                                     233791
SD000770P                                                                                     233791
SD000771P                                                                                     233791
SD000771P                                                                                     233791
SD000772P                                                                                     233791
SD000772P                                                                                     233791
SD000780P                                                                                     233791
SD000780P                                                                                     233791
SD000790P                                                                                   BUG24056
SD000790P                                                                                   BUG24056
GL001600                                                                                    BUG25288
GL001600                                                                                    BUG25288
GL0150U                                                                                     BUG25288
GP004001                                                                                    AR883675
GP004001                                                                                   AR1061934
GP004002                                                                                    AR883675
GP004002                                                                                   AR1061934
GP004003                                                                                    AR883675
GP004003                                                                                   AR1061934
GP004004                                                                                    AR883675
GP004004                                                                                   AR1061934
GP004005                                                                                    AR883675
GP004005                                                                                   AR1061934
GP004006                                                                                    AR883675
GP004006                                                                                   AR1061934
RE3772                                                                                     AR1061934
RE3772                                                                                     AR1061934
RE3772                                                                                     AR1061934
**                                                                                            CSC042
OVRDBF FILE(MAARCDPD) TOFILE(*FILE) OVRSCOPE(*JOB) SEQONLY(*NO)                               CSC042

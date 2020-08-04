     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas CB COB report submission')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Close Of Business Processing                         *
     F*                                                               *
     F*  CB0055 - CALL ALL CLOSE OF BUSINESS ON REQUEST REPORTS       *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247203             Date 25Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10349           Date 06Feb06               *
      *                 BUG2989            Date 15Jun04               *
      *                 107700             Date 24Jul03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 197767             Date 28Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CCB009             Date 23Jun00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 098640             Date 28Jan98               *
     F*                    101930           Date 08Jul96              *
     F*                    081912           DATE 18JAN95              *
     F*                    064115           DATE 18FEB94              *
     F*                    E38634           DATE 24APR92              *
     F*                    E36396           DATE 28FEB92              *
     F*                    LN0989           DATE 12DEC90              *
     F*                    LN0545           DATE 20JUL90              *
     F*                    LN0486           DATE 13JUL90              *
     F*                    LN0278           DATE 13JUL90              *
     F*                    LN0497           DATE  9JUL90              *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  247203 - Set Halt After status to 'H' once halt is in        *
      *           progress so that Halt After message is correct.     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10349 - Wrong record retrieved from FCRREQL8              *
      *  BUG2989 - Check CBCOBRL0 before issue of DBERROR for COB on  *
      *            request components not existing on FCRREQL8.      *
      *  107700 - Update the Stream Number field on CBCOMSPD with     *
      *           the stream in which the component is running.       *
      *           - Reintroduction of lost change.                    *
      *  197767 - CB0300 shows for failed components incorrect time   *
      *           duration containing alphabets and brackets. Ensure  *
      *           that fields DHCETI and DHCEDE in file CBCOMSPD are  *
      *           updated with values from CBTIME if component failed.*
     F*  CCB009 - Journal files throughout the close of business.     *
     F*           Write a record to CBAUDTL1 when component starts.   *
     F*  098640 - If CBCOMSPD record is locked (RPG1218 received),    *
     F*           continue reading CBCOMSL0 until record is available,*
     F*           instead of terminating abnormally.                  *
     F*  101930 - Apply Autocall changes to CBC0055 (for On Request   *
     F*           reports) as well as CBC0050 (Mandatory reports)     *
     F*  081912 - Correct concatenation of command string. Allow      *
     F*           256 characters                                      *
     F*  064115 - PROCESS REPORT COMPONENTS WHICH EXIST ON            *
     F*           SWITCHABLE FEATURES BY REPORT COMPONENTS FILE.      *
     F*           REPLACE LF/FCRCOML3 WITH JLF/FCRCOMJ3               *
     F*     E38634  -  Add an extra chain to CBCOMSPD if an error has   *
     F*                occurred when accessing one of the RCF files.    *
     F*                This is to prevent 'UPDAT without prior READ/    *
     F*                CHAIN' error occurring during the DBERR          *
     F*                subroutine.                                      *
     F*     E36396  -  WHEN REQUEST REPORT FAILED, RUN TIME FIELD IN    *
     F*                CB0300 PRINTS OUT RUBBISH: DHCEDE IS BEING       *
     F*                UPDATED INSTEAD OF CEDE FOR END DATE IN FILE     *
     F*                CBAUDTPD WHICH RESULTS IN 0 END DATE BEING       *
     F*                PROCESSED FOR FAILED COMPONENTS IN CB0300.       *
     F*     LN0989  -  PROVIDE ADDITIONAL COB ERROR INFORMATION         *
     F*     LN0545  -  RE-TRY THE LOCK OF CBSTAT TO AVOID POTENTIAL     *
     F*                COB CRASH AS A NUMBER OF PROGRAMS PERFORM THE    *
     F*                *LOCK TO UPDATE THE DATA AREA                    *
     F*     LN0486  -  CORRECT DATABASE ERROR PROCESSING -              *
     F*                PROGRAM MUST ALWAYS ATTEMPT TO UPDATE            *
     F*                FAILED COMPONENT STATUS IN CASE OF ERROR         *
     F*     LN0278  -  USE NEW PROGRAM CBTIME TO ACCESS TIME AND        *
     F*                DATE IN CORRECT FORMAT FOR CALCULATIONS          *
     F*                AND REMOVE ZDATE1 SUBROUTINE                     *
     F*     LN0497  -  CHANGED SPECIFICATION OF LENGTH OF FIELD SENT    *
     F*                TO CBDTQA TO P(5,0) AS ERROR WAS OCCURRING IN    *
     F*                QSNDDTAQ COMMAND.                                *
     F*                LENGTH OF CBDTQA IS 16.                          *
     F*                LDA HANDLING ALTERED.                            *
     F*                SPECIFICATION OF LENGTH OF CBSTAT ELSE PROGRAM   *
     F*                CANNOT ACCESS THE EXTERNAL DATA AREA.            *
     F********************************************************************
     FCBCOMSL0  UF   E           K DISK
     F                                     INFDS(COMDS)                         098640
     FFCRREQL8  IF   E           K DISK
     FFCPARDL1  IF   E           K DISK
     F***FCRCOML3IF  E           K        DISK                            064115
     F*FCRCOMJ3* IF   E           K DISK                                         064115     MD055265
     FCBCOBRL0  IF   E           K DISK                                                            B
     F*CBAUDTPDO**E***                 DISK                           UC  CCB009
     FCBAUDTL1  UF A E           K DISK    USROPN                               CCB009
     F/COPY WNCPYSRC,CB0055F001
     F********************************************************************
     F*
     F*        FUNCTION OF INDICATORS
     F*
     F*  30    CHAIN FAIL
     F*  31    SETLL FINDS NO RECORDS
     F*  32    END OF RECORDS ON FCRREQL8
     F*  36    No record in audit file - CBAUDTL1                         CCB009
     F*  70    RE-TRY LOCK OF DATA AREA                                   LN0545
     F*
     F********************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D**********          ARR     1   1 20                                LN0497
     D ARR             S             16    DIM(1) CTDATA PERRCD(1)                               LN0
     D****/COPY ZSRSRC,ZDATE1Z1                                           LN0278
     D*
     D*CBSTAT***** DS                                                     LN0497
     D COMDS           DS           366                                         098640
     D  FSTAT            *STATUS                                                098640
     D CBSTAT          DS            50                                         LN0497
     D*
     D** CLOSE OF BUSINESS HALT INDICATOR
     D*
     D  HALT                  20     20
     D*
     D RUNDAT          DS
     D*
     D** RUN DATE, DATE FORMAT, MULTIBRANCH INDICATOR AND SET UP FLAG
     D*
     D  RUNA                   1      7
     D  RUND                   8     10  0
     D  SSF                   11     11
     D***********                            12  12 DATF                  LN0278
     D  MBIN                  13     13
     D*                                                                   101930
     D ACCOBT          DS            10                                         101930
     D  ACCBTP                 1      1                                         101930
     D** AUTOCALL DATA AREA TO DEFINE COB TYPE                            101930
     D*
     D RCOMK           DS
     D*
     D** DATASTRUCTURE FOR REPORT REQUESTS KEY
     D*
     D**D3COTT**               1     10                                                     MD055265
     D  X3COTT                 1     10                                                     MD055265
     D**D3CSEQ                11     15                                                     MD055265
     D  X3CSEQ                11     15                                                     MD055265
     D*
     D RREQK           DS
     D*
     D** DATASTRUCTURE FOR REPORT REQUESTS KEY
     D*
     D  D5RNAM                 1     10
     D  D5COTT                11     20
     D  D5CSEQ                21     25
     D*
     D COMSK           DS
     D*
     D** DATASTRUCTURE FOR REPORT REQUESTS KEY
     D*
     D  DHCOTT                 1     10
     D  DHCSEQ                11     15
     D*                                                                   CCB009
     D AUDKDS          DS                                                       CCB009
     D*                                                                   CCB009
     D** DATA STRUCTURE FOR KEY FIELD AUDKEY TO BE MOVED INTO DBKEY FIELD CCB009
     D*                                                                   CCB009
     D  CCOTX                  1     10                                         CCB009
     D  CSEQX                 11     15                                         CCB009
     D  CSDEX                 16     20                                         CCB009
     D  CSTIX                 21     26                                         CCB009
     D*
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
     D EPPDS          SDS                                                       LN0989
     D  JOJOB                244    253                                         LN0989
     D  JOUSER               254    263                                         LN0989
     D  JONBR                264    269  0                                      LN0989
     I**  PROGRAM STATUS DATA STRUCTURE                                   LN0989
     I**  INFORMATION USED BY ERROR PROCESSING                            LN0989
     I*                                                                   LN0989
     D FCRCOM        E DS                  EXTNAME(FCRCOJW1)                                MD055265
     D NullInds        s              5i 0 dim(12)                                          MD055265
     C                   MOVEA     CPY@          BIS@             80
     C*
      ** ENTRY PARAMETERS
     C*
     C     *ENTRY        PLIST
     C                   PARM                    COTT
     C                   PARM                    CSEQA             5
     C                   PARM                    STS               1
     C                   PARM                    CMEDT             6 0                         10193
     C                   PARM                    STREAM            8
      *
     C     *LIKE         DEFINE    DHCOTT        COTT
     C*
      ** KEY LISTS
     C*
     C     RREQ          KLIST
     C                   KFLD                    D5RNAM
     C                   KFLD                    D5COTT
     C                   KFLD                    D5CSEQ
      *                                                                                      BUG2989
     C     RREQ2         KLIST
     C                   KFLD                    D5COTT
     C                   KFLD                    D5CSEQ
     C*
     C     PARD          KLIST
     C                   KFLD                    D7RNAM
     C                   KFLD                    D7RQSQ
     C*
     C     RCOM          KLIST
     C                   KFLD                    D3COTT
     C                   KFLD                    D3CSEQ
     C*
     C     COMS          KLIST
     C                   KFLD                    DHCOTT
     C                   KFLD                    DHCSEQ
     C*                                                                   CCB009
     C** Key to chain to CBAUDTL1                                         CCB009
     C*                                                                   CCB009
     C     AUDKEY        KLIST                                                                 CCB00
     C                   KFLD                    CCOT                                          CCB00
     C                   KFLD                    CSEQ                                          CCB00
     C                   KFLD                    CSDE                                          CCB00
     C                   KFLD                    CSTI                                          CCB00
     C*
      ***SET*DATE*FORMAT*FLAG*FOR*ZDATE*ROUTINES                          LN0278
     C*
     C*****      *NAMVAR   DEFN           RUNDAT                          LN0278
     C*****                IN   RUNDAT                                    LN0278
     C*****      DATF      COMP 'M'                      98               LN0278
      *                                                                   LN0497
      * IF QSNDDTAQ FAILS THERE IS NOTHING TO SUGGEST IT HAPPENED IN      LN0497
      * THIS PROGRAM.                                                     LN0497
     C     *DTAARA       DEFINE                  LDA                                           LN049
     C     *LOCK         IN        LDA                                                         LN049
     C                   MOVEL     'CB0055'      DBPGM                                         LN049
     C                   OUT       LDA                                                         LN049
      *                                                                   CCB009
      ** Set flag to show whether Audit file has been written             CCB009
     C                   MOVE      'N'           WAUDT             1                           CCB00
      *                                                                   101930
      ** Access Switchable features file to check if Autocall in ON       101930
      *                                                                   101930
     C                   MOVE      'N'           S01491            1                           10193
     C                   CALL      'AOSARDR0'                                                  10193
     C                   PARM      '       '     @RTCD             7                           10193
     C                   PARM      '*VERIFY'     @OPTN             7                           10193
     C                   PARM      'S01491 '     @SARD             6                           10193
     C     @RTCD         IFEQ      *BLANKS                                                     10193
     C                   MOVE      'Y'           S01491                                        10193
     C                   END                                                                   10193
     C/COPY WNCPYSRC,CB0055C001
      *
      ** Access Close of Business Components file for this component/seq
      *
     C                   MOVE      CSEQA         CSEQ
     C                   MOVE      COTT          DHCOTT
     C                   MOVE      CSEQ          DHCSEQ
     C***********COMS      CHAINCBCOMSL0             30                   098640
      * LOOP IF RECORD IS TEMPORARILLY LOCKED                             098640
     C     *IN35         DOUEQ     '0'                                                         09864
     C     COMS          CHAIN     CBCOMSL0                           3035                     09864
     C     *IN35         IFEQ      '1'                                                         09864
     C     FSTAT         ANDNE     1218                                                        09864
     C                   EXSR      *PSSR                                                       09864
     C                   END                                                                   09864
     C                   END                                                                   09864
      *
      ** If no record is found
      **      Database error
      *
     C     *IN30         IFEQ      '1'
     C********** *NAMVAR   DEFN           LDA                             LN0497
     C     *LOCK         IN        LDA
     C                   MOVE      COMSK         DBKEY                          ***************
     C                   MOVE      'CBCOMSL0'    DBFILE                         * DB ERR  001 *
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'CB0055'      DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
      ** Update Close of Business Components with start date/time
      *
     C********             TIME           TIMDAT 120                      LN0278
     C*                                                                   LN0278
     C** ACCESS DATE, TIME AND DATE FORMAT USING PROGRAM CBTIME           LN0278
     C*                                                                   LN0278
     C                   CALL      'CBTIME'                                                    LN027
     C                   PARM                    DAYNOA            5                           LN027
     C                   PARM                    STIME             6                           LN027
     C                   PARM                    DFMT              1                           LN027
     C******               MOVELTIMDAT    DHCSTI                          LN0278
      *                                                                                       197767
      ** Change time to greater than 00:00:00 as the system                                   197767
      ** may fail to change the date until 00:00:01.                                          197767
      *                                                                                       197767
     C                   MOVE      STIME         ST2               6 0
     C     ST2           IFEQ      0
     C                   EXSR      TIMSR
     C                   ENDIF
      *                                                                                       197767
     C                   MOVE      STIME         DHCSTI                                        LN027
     C******               MOVE TIMDAT    ZDATE                           LN0278
     C******               EXSR ZDATE1                                    LN0278
     C******               Z-ADDZDAYNO    DHCSDE                          LN0278
     C                   MOVE      DAYNOA        DHCSDE                                        LN027
     C                   MOVE      'P'           DHCSTS
     C                   MOVE      STREAM        DHCBSN
      *                                                                   101930
      ** If Autocall is ON, pick up the estimated time for the given      101930
      ** component.                                                       101930
      *                                                                   101930
     C                   Z-ADD     0             CMEDT             6 0                         10193
     C     S01491        IFEQ      'Y'                                                         10193
     C                   EXSR      ACSR1                                                       10193
     C                   END                                                                   10193
      *                                                                   101930
     C                   UPDATE    @DHREGG
      *                                                                   101930
      ** If Autocall is ON, call AC0001 to calculate the end time for the 101930
      ** given component                                                  101930
      *                                                                   101930
     C     S01491        IFEQ      'Y'                                                         10193
     C                   EXSR      ACSR2                                                       10193
     C                   END                                                                   10193
     C*                                                                   CCB009
     C** Open failed details file CBAUDTL1.                               CCB009
     C*                                                                   CCB009
     C                   OPEN      CBAUDTL1                                                    CCB00
     C*                                                                   CCB009
     C** Set up component name and sequence number to write out           CCB009
     C** to LF/CBAUDTL1.                                                  CCB009
     C*                                                                   CCB009
     C                   MOVE      DHCOTT        CCOT                                          CCB00
     C                   MOVE      DHCSEQ        CSEQ                                          CCB00
     C*                                                                   CCB009
     C** Set component end date and time to zero.                         CCB009
     C*                                                                   CCB009
     C                   Z-ADD     0             CETI                                          CCB00
     C                   Z-ADD     0             CEDE                                          CCB00
     C*                                                                   CCB009
     C** Retrieve component start time and date from work fields.         CCB009
     C*                                                                   CCB009
     C                   MOVE      DHCSTI        CSTI                                          CCB00
     C                   MOVE      DHCSDE        CSDE                                          CCB00
     C*                                                                   CCB009
     C** Write record to failed details file.                             CCB009
     C*                                                                   CCB009
     C                   WRITE     CBAUDTP0                                                    CCB00
     C*                                                                   CCB009
      ** Set flag to show whether Audit file has been written             CCB009
     C                   MOVE      'Y'           WAUDT                                         CCB00
     C*                                                                   CCB009
     C** Close failed details file.                                       CCB009
     C*                                                                   CCB009
     C                   CLOSE     CBAUDTL1                                                    CCB00
      *
      ** Access Report Components file with component/seq to get report name
      *
     C                   MOVE      COTT          D3COTT
     C                   MOVE      CSEQ          D3CSEQ
     C                   MOVE      COTT          X3COTT                                     MD055265
     C                   MOVE      CSEQ          X3CSEQ                                     MD055265
     C***********RCOM      CHAINFCRCOML3             30                   064115
     C*****RCOM          CHAIN     FCRCOMJ3                           30              06411 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRCOM :NullInds                                                              MD055265
     C+ from FCRCOJW1                                                                       MD055265
     C+ where D3COTT = :D3COTT and D3CSEQ = :D3CSEQ                                         MD055265
     C/END-EXEC                                                                             MD055265
      *
      ** If no record found
      **     Database error
      *
     C******IN30         IFEQ      '1'                                                      MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C     *LOCK         IN        LDA
     C                   MOVE      RCOMK         DBKEY                          ***************
     C*********************MOVE 'FCRCOML3'DBFILE           * DB ERR  002 *064115
     C                   MOVE      'FCRCOMJ3'    DBFILE                         * DB ERR  002 *06411
     C                   Z-ADD     2             DBASE                          ***************
     C                   MOVEL     'CB0055'      DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
      ** Set Lower Limits on Report Requests for the report name
      *
     C                   MOVE      D3RNAM        D5RNAM
     C                   MOVE      COTT          D5COTT
     C                   MOVE      CSEQ          D5CSEQ
     C     RREQ          SETLL     FCRREQL8                               31
      *
      ** If no records exist for the report name
      **     Database error
      *
     C                   MOVE      *BLANK        WNTFND            1
     C     *IN31         IFEQ      '0'
      *                                                                                     BUG10349
      ** If record not found on FCRREQPD, blank out parameter being passed to               BUG10349
      ** CBC0056                                                                            BUG10349
      *                                                                                     BUG10349
     C                   MOVE      *BLANK        D5RQSQ
     C                   MOVE      *BLANK        D5LVL
     C                   MOVE      *BLANK        D5ETTY
     C                   MOVE      'Y'           WNTFND
      *                                                                                      BUG2989
      ** If not found FCRREQL8, search for it in CBCOBRL0                                    BUG2989
      *                                                                                      BUG2989
     C     RREQ2         SETLL     CBCOBRL0                               31
      *                                                                                      BUG2989
      ** if still not found then issue DBERROR                                               BUG2989
      *                                                                                      BUG2989
     C     *IN31         IFEQ      '0'
     C     *LOCK         IN        LDA
     C                   MOVEL     RREQK         DBKEY                          ***************
     C                   MOVE      'FCRREQL8'    DBFILE                         * DB ERR  003 *
     C                   Z-ADD     3             DBASE                          ***************
     C                   MOVEL     'CB0055'      DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
     C                   ENDIF
      *
      ** Access first request for this report
      *
     C     WNTFND        IFEQ      *BLANK
     C                   READ      FCRREQL8                               32
     C                   ENDIF
     C                   EXSR      PROCRQ
      *
     C                   MOVEL     D3COTT        X3COTT                                     MD055265
     C                   MOVEL     D3CSEQ        X3CSEQ                                     MD055265
      ** Access Component record
      *
     C***********RCOM      CHAINFCRCOML3             30                   064115
     C*****RCOM          CHAIN     FCRCOMJ3                           30              06411 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRCOM :NullInds                                                              MD055265
     C+ from FCRCOJW1                                                                       MD055265
     C+ where D3COTT = :D3COTT and D3CSEQ = :D3CSEQ                                         MD055265
     C/END-EXEC                                                                             MD055265
      *
      ** If no record found
      **     Database error
      *
     C******IN30         IFEQ      '1'                                                      MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C     *LOCK         IN        LDA
     C                   MOVE      RCOMK         DBKEY                          ***************
     C*********************MOVE 'FCRCOML3'DBFILE           * DB ERR  004 *064115
     C                   MOVE      'FCRCOMJ3'    DBFILE                         * DB ERR  004 *06411
     C                   Z-ADD     4             DBASE                          ***************
     C                   MOVEL     'CB0055'      DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
     C***********COMS      CHAINCBCOMSL0             30                   098640
      * LOOP IF RECORD IS TEMPORARILLY LOCKED                             098640
     C     *IN35         DOUEQ     '0'                                                         09864
     C     COMS          CHAIN     CBCOMSL0                           3035                     09864
     C     *IN35         IFEQ      '1'                                                         09864
     C     FSTAT         ANDNE     1218                                                        09864
     C                   EXSR      *PSSR                                                       09864
     C                   END                                                                   09864
     C                   END                                                                   09864
      *
      ** If no record is found
      **      Database error
      *
     C     *IN30         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      COMSK         DBKEY                          ***************
     C                   MOVE      'CBCOMSL0'    DBFILE                         * DB ERR  005 *
     C                   Z-ADD     5             DBASE                          ***************
     C                   MOVEL     'CB0055'      DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
      ** Update Component record to completed
      *
     C                   MOVE      'C'           DHCSTS
     C********             TIME           TIMDAT 120                      LN0278
     C*                                                                   LN0278
     C** ACCESS DATE, TIME AND DATE FORMAT USING PROGRAM CBTIME           LN0278
     C*                                                                   LN0278
     C                   CALL      'CBTIME'                                                    LN027
     C                   PARM                    DAYNOA                                        LN027
     C                   PARM                    STIME                                         LN027
     C                   PARM                    DFMT                                          LN027
      *                                                                                       197767
      ** Apply time fix as above.                                                             197767
      *                                                                                       197767
     C                   MOVE      STIME         ST2
     C     ST2           IFEQ      0
     C                   EXSR      TIMSR
     C                   ENDIF
      *                                                                                       197767
     C******               MOVE TIMDAT    ZDATE                           LN0278
     C******               EXSR ZDATE1                                    LN0278
     C******               Z-ADDZDAYNO    DHCEDE                          LN0278
     C                   MOVE      DAYNOA        DHCEDE                                        LN027
     C******               MOVELTIMDAT    DHCETI                          LN0278
     C                   MOVE      STIME         DHCETI                                        LN027
     C*                                                                                       247203
     C     DHCHTA        IFEQ      'Y'
     C                   MOVE      'H'           DHCHTA
     C                   ENDIF
      *
     C                   UPDATE    @DHREGG
      *
      ** Set parameter status to completed
      *
     C                   MOVE      'C'           STS
      *
      ** If halt after component field from component record is 'Y'
      ** AND no halt is currently outstanding (CBSTAT position 20)
      **     Send message to halt to CBDTQA
      **     Update CBSTAT to 'R' (Halt in progress)
      *
     C***********DHCHTA    IFEQ 'Y'                                                           247203
     C     DHCHTA        IFEQ      'H'
     C     *DTAARA       DEFINE                  CBSTAT
     C     *IN70         DOUEQ     '0'                                                         LN054
     C************LOCK     IN   CBSTAT                                    LN0545
     C     *LOCK         IN        CBSTAT                               70                     LN054
     C                   END                                                                   LN054
      *
     C     HALT          IFEQ      'N'
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'CBDTQA'      QUEUE            10
     C                   PARM      '*LIBL'       LIB              10
     C**********           PARM 20        LEN    150                      LN0497
     C                   PARM      16            LEN               5 0                         LN049
     C**********           PARM ARR,1     MSG    20                       LN0497
     C                   PARM      ARR(1)        MSG              16                           LN049
     C                   MOVE      'R'           HALT
     C                   END
      *
     C                   OUT       CBSTAT
     C                   END
      *
     C                   EXSR      END
      ********************************************************************
      *            INDEX OF SUBROUTINES
      **     PROCRQ - PROCESS FCRREQL8 RECORDS
      **     DBERR - PROCESS DATABASE ERROR
      **     ERROR - WRITE ERROR RECORD
      **     END - TERMINATE PROGRAM
      **     ZDATE1 - STANDARD MIDAS SUBROUTINE DATE > DAY NUMBER
      **     ACSR1  - AUTOCALL SR. TO PICK UP 'TIME TAKEN' FOR COMPONENT. 101930
      **     ACSR2  - AUTOCALL SR. TO CALCULATE END TIME FOR COMPONENT.   101930
     C**     *PSSR -  TERMINATES PROGRAM IF EXCEPTION ERROR OCCURS
      **     TIMSR -  SR to correct error when time = 0.                                      197767
      ********************************************************************
      /EJECT
      ********************************************************************
      ** S/R PROCRQ - PROCESS FCRREQL8 RECORDS
      ** CALLED FROM MAIN PROCESSING
      ** CALLS ERROR DBERR
      ********************************************************************
      *
     C     PROCRQ        BEGSR
      *
      ** DOWHILE Requests remain for this report
      *
     C***********          MOVE DHCPRM    PMHOLD100                       081912
     C                   MOVEL     *BLANKS       PMHOLD          256                           08191
     C                   MOVEL     DHCPRM        PMHOLD                                        08191
     C     *IN32         DOWEQ     '0'
      *
      **     Access Report Parameters for this report/seq
      *
     C                   MOVE      D5RNAM        D7RNAM
     C                   MOVE      D5RQSQ        D7RQSQ
      *
     C     PARD          CHAIN     FCPARDL1                           30
      *
      **     If no record is found
      **          Set parameter fields to blank
      *
     C     *IN30         IFEQ      '1'
     C                   MOVE      *BLANK        D7PARM
     C                   END
     C/COPY WNCPYSRC,CB0055C002
      *
      **     Call Parameter concatenation program
      *
     C                   MOVEL     *BLANKS       O#CPRM                                        08191
     C                   MOVEL     DHCPRM        O#CPRM                                        08191
      *                                                                   081912
     C                   CALL      'CBC0056'
     C**********           PARM           DHCPRM                          081912
     C                   PARM                    O#CPRM          256                           08191
     C                   PARM                    D5RQSQ
     C                   PARM                    D5LVL
     C                   PARM                    D5ETTY
     C                   PARM                    D7PARM
     C/COPY WNCPYSRC,CB0055C003
      *
      **     Call Close of Business component submission program
      *
     C                   CALL      'CBC0051'
     C                   PARM                    DHCOTT
     C**********           PARM           DHCPRM                          081912
     C                   PARM                    O#CPRM                                        08191
     C                   PARM      '0'           INU7              1
     C                   PARM      '0'           INU8              1
     C                   PARM                    ERR               1
      *
      **     Set indicators as returned
      *
     C                   MOVE      INU7          *INU7
     C                   MOVE      INU8          *INU8
      *
      **     If U7 is on
      **     OR U8 is on and FCOOB is not 'Y' for the component
      **     OR 'ERROR' is '1'
      **          Access Component record
      *
     C     *INU7         IFEQ      '1'
     C     *INU8         OREQ      '1'
     C     DHCFOB        ANDNE     'Y'
     C     ERR           OREQ      '1'
     C***********COMS      CHAINCBCOMSL0             30                   098640
      * LOOP IF RECORD IS TEMPORARILLY LOCKED                             098640
     C     *IN35         DOUEQ     '0'                                                         09864
     C     COMS          CHAIN     CBCOMSL0                           3035                     09864
     C     *IN35         IFEQ      '1'                                                         09864
     C     FSTAT         ANDNE     1218                                                        09864
     C                   EXSR      *PSSR                                                       09864
     C                   END                                                                   09864
     C                   END                                                                   09864
      *
      **          If no record found
      **               Database error
      *
     C     *IN30         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      COMSK         DBKEY                          ***************
     C                   MOVE      'CBCOMSL0'    DBFILE                         * DB ERR  006 *
     C                   Z-ADD     6             DBASE                          ***************
     C                   MOVEL     'CB0055'      DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
      *********** Update*Component*to*failed*status                       LN0486
      *
     C******               MOVE 'A'       DHCSTS                          LN0486
     C******               MOVE 'Y'       DHCFAL                          LN0486
     C******               UPDAT@DHREGG                                   LN0486
      *
      **          Write audit record
      **          Set status to 'A' for return
      *
     C                   EXSR      ERROR
      *
      **          Terminate Program
      *
     C                   EXSR      END
      *
     C                   END
      *
     C     RREQ          READE     FCRREQL8                               32
      *
     C                   MOVE      *BLANK        DHCPRM
     C**********           MOVE PMHOLD    DHCPRM                          081912
     C                   MOVEL     PMHOLD        DHCPRM                                        08191
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      ** S/R DBERR - PROCESS DATABASE ERROR
      ** CALLED FROM MAIN PROCESSING, PROCRC
      ** CALLS END
      ********************************************************************
      *
     C     DBERR         BEGSR
      *
     C                   SETON                                        U7U8
      *
      **  If the error has occurred in an access to one of the RCF
      **  files then do a further 'CHAIN' into CBCOMSPD to prevent
      **  IBM error message appearing
      *
     C     DBASE         IFEQ      2
     C     DBASE         OREQ      3
     C     DBASE         OREQ      4
     C*
     C***********COMS      CHAINCBCOMSL0             30                   098640
      * LOOP IF RECORD IS TEMPORARILLY LOCKED                             098640
     C     *IN35         DOUEQ     '0'                                                         09864
     C     COMS          CHAIN     CBCOMSL0                           3035                     09864
     C     *IN35         IFEQ      '1'                                                         09864
     C     FSTAT         ANDNE     1218                                                        09864
     C                   EXSR      *PSSR                                                       09864
     C                   END                                                                   09864
     C                   END                                                                   09864
     C*
     C                   END
      *
      **               Write audit record
      **               Set status to 'A' for return
      *
     C                   EXSR      ERROR
      *
      **          Terminate Program
      *
     C                   EXSR      END
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      ** S/R ERROR - WRITE ERROR RECORD & UPDATE ERROR DETAILS ON         LN0486
      **             COMPONENTS FILE                                      LN0486
      ** CALLED FROM MAIN PROCESSING, PROCRC
      ** CALLS NO OTHER SUBROUTINES
      ********************************************************************
      *
     C     ERROR         BEGSR
      *
      *                                                                   LN0486
      *           Update Component to failed status                       LN0486
      *                                                                   LN0486
     C                   MOVE      'A'           DHCSTS                                        LN048
     C                   MOVE      'Y'           DHCFAL                                        LN048
      *                                                                                       197767
      ** Update of CBCMOMSL0 should be after the issue of CBTIME.                             197767
      *                                                                                       197767
     C**********           UPDAT@DHREGG                                                LN0486 197767
      *                                                                   LN0486
      **          Set status to 'A' for return
      *
     C                   MOVE      'A'           STS
      *
     C***********          OPEN CBAUDTPD                                  CCB009
     C                   OPEN      CBAUDTL1                                                    CCB00
      *
      **          Write audit record
      ** or Update audit record if already written                        CCB009
      *
     C     WAUDT         IFEQ      'N'                                                         CCB00
      *                                                                   CCB009
     C                   MOVE      DHCOTT        CCOT
     C                   MOVE      DHCSEQ        CSEQ
     C*****                MOVE TIMDAT    CSDE                            LN0278
     C                   MOVE      DAYNOA        CSDE                                          LN027
     C******               MOVELTIMDAT    CSTI                            LN0278
     C                   MOVEL     STIME         CSTI                                          LN027
     C********             TIME           TIMDAT                          LN0278
      *                                                                   CCB009
     C                   ELSE                                                                  CCB00
      *                                                                   CCB009
      ** Chain to component start record on LF/CBAUDTL1.                  CCB009
      *                                                                   CCB009
     C     AUDKEY        CHAIN     CBAUDTL1                           36                       CCB00
      *                                                                   CCB009
      ** If no record found on CBAUDTL1, set                              CCB009
      ** component status parameter to 'A'                                CCB009
      *                                                                   CCB009
     C     *IN36         IFEQ      '1'                                                         CCB00
     C                   MOVE      'A'           STS                                           CCB00
     C     *LOCK         IN        LDA                                                         CCB00
     C                   MOVE      CCOT          CCOTX                                         CCB00
     C                   MOVE      CSEQ          CSEQX                                         CCB00
     C                   MOVE      CSDE          CSDEX                                         CCB00
     C                   MOVE      CSTI          CSTIX                                         CCB00
     C                   MOVEL     AUDKDS        DBKEY                          ***************CCB00
     C                   MOVEL     'CBAUDTL1'    DBFILE                         * DB ERROR 08 *CCB00
     C                   Z-ADD     8             DBASE                          ***************CCB00
     C                   ENDIF                                                                 CCB00
      *                                                                   CCB009
     C                   ENDIF                                                                 CCB00
     C*                                                                   LN0278
     C** ACCESS DATE, TIME AND DATE FORMAT USING PROGRAM CBTIME           LN0278
     C*                                                                   LN0278
     C                   CALL      'CBTIME'                                                    LN027
     C                   PARM                    DAYNOA            5                           LN027
     C                   PARM                    STIME             6                           LN027
     C                   PARM                    DFMT              1                           LN027
     C******               MOVE TIMDAT    ZDATE                           LN0278
     C******               EXSR ZDATE1                                    LN0278
     C******               Z-ADDZDAYNO    DHCEDE                          LN0278
     C***********          MOVE DAYNOA    DHCEDE                    LN0278E36396
      *                                                                                       197767
      ** Apply time fix as above.                                                             197767
      *                                                                                       197767
     C                   MOVE      STIME         ST2
     C     ST2           IFEQ      0
     C                   EXSR      TIMSR
     C                   ENDIF
      *                                                                                       197767
     C                   MOVE      DAYNOA        CEDE                                          E3639
     C******               MOVELTIMDAT    CETI                            LN0278
     C                   MOVE      STIME         CETI                                          LN027
      *
     C     WAUDT         IFEQ      'N'                                                         CCB00
     C                   WRITE     CBAUDTP0
     C                   ELSE                                                                  CCB00
     C                   UPDATE    CBAUDTP0                                                    CCB00
     C                   ENDIF                                                                 CCB00
      *                                                                   CCB009
     C                   CLOSE     CBAUDTL1                                                    CCB00
      *                                                                                       197767
      ** If component fails, also update fields DHCETI and DHCEDE of                          197767
      ** CBCOMSPD to avoid end time/date = 0.                                                 197767
      *                                                                                       197767
     C                   MOVE      DAYNOA        DHCEDE
     C                   MOVE      STIME         DHCETI
     C                   UPDATE    @DHREGG
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      ** S/R END - TERMINATE PROGRAM
      ** CALLED FROM MAIN PROCESSING, PROCRC, DBERR
      ** CALLS NO OTHER SUBROUTINES
      ********************************************************************
      *
     C     END           BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      ********************************************************************
      /EJECT
     E*****/COPY ZSRSRC,ZDATE1Z2                                          LN0278
      /EJECT                                                              101930
      ********************************************************************101930
      *                                                                   101930
      *  Subroutine ACSR1  - Find the 'time taken' for component          101930
      *                                                                   101930
      *  Called by: Main processing, if Autocall (S01491) is ON           101930
      *                                                                   101930
      ********************************************************************101930
      *                                                                   101930
     C     ACSR1         BEGSR                                                                 10193
      *                                                                   101930
     C     *DTAARA       DEFINE                  ACCOBT                                        10193
     C                   IN        ACCOBT                                                      10193
      *                                                                   101930
     C     ACCBTP        IFEQ      'Y'                                                         10193
     C                   Z-ADD     DHEOYT        CMEDT                                         10193
     C                   END                                                                   10193
      *                                                                   101930
     C     ACCBTP        IFEQ      'B'                                                         10193
     C                   Z-ADD     DHBOMT        CMEDT                                         10193
     C                   END                                                                   10193
      *                                                                   101930
     C     ACCBTP        IFEQ      'M'                                                         10193
     C                   Z-ADD     DHEOMT        CMEDT                                         10193
     C                   END                                                                   10193
      *                                                                   101930
     C     ACCBTP        IFEQ      'D'                                                         10193
     C                   Z-ADD     DHEODT        CMEDT                                         10193
     C                   END                                                                   10193
      *                                                                   101930
     C     ACSR19        ENDSR                                                                 10193
      *                                                                   101930
      ********************************************************************101930
      /EJECT                                                              101930
      ********************************************************************101930
      *                                                                   101930
      *  Subroutine ACSR2  - Calculate the 'end time' for component       101930
      *                                                                   101930
      *  Called by: Main processing, if Autocall (S01491) is ON           101930
      *                                                                   101930
      ********************************************************************101930
      *                                                                   101930
     C     ACSR2         BEGSR                                                                 10193
      *                                                                   101930
     C                   CALL      'AC0001'                                                    10193
     C                   PARM                    COTT                                          10193
     C                   PARM                    CSEQA                                         10193
     C                   PARM                    CMEDT                                         10193
     C                   PARM      'A'           MODE              1                           10193
      *                                                                   101930
     C     ACSR29        ENDSR                                                                 10193
      *                                                                   101930
      ********************************************************************101930
      /EJECT
     C********************************************************************
     C**                                                                 *
     C**   *PSSR SR. -  Database Error Handling : Terminates program;    *
     C**   ~~~~~~~~~                                                     *
     C**                                                                 *
     C**
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C**
     C**  Write out component in error details
     C**
     C***********COMS      CHAINCBCOMSL0             30                   098640
      * LOOP IF RECORD IS TEMPORARILLY LOCKED                             098640
     C     *IN35         DOUEQ     '0'                                                         09864
     C     COMS          CHAIN     CBCOMSL0                           3035                     09864
     C                   END                                                                   09864
      *
      **          If no record found update LDA
      **            with database error values
      *
     C     *IN30         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      COMSK         DBKEY                          ***************
     C                   MOVE      'CBCOMSL0'    DBFILE                         * DB ERR  007 *
     C                   Z-ADD     7             DBASE                          ***************
     C                   MOVEL     'CB0055'      DBPGM
     C                   OUT       LDA
     C**********           ELSE                                           LN0486
      *
      ************Update*Component*to*failed*status                       LN0486
      *
     C**********           MOVE 'A'       DHCSTS                          LN0486
     C**********           MOVE 'Y'       DHCFAL                          LN0486
     C**********           UPDAT@DHREGG                                   LN0486
     C                   END
      *
     C                   EXSR      ERROR
     C                   DUMP
     C                   END
     C                   RETURN
     C                   ENDSR
      ****************************************************************
      *  TIMSR - Correct errors caused when time = 0.                 *                       197767
      *                                                               *                       197767
      *  Called by: Activated when time = 0.                          *                       197767
      *                                                               *                       197767
      *****************************************************************                       197767
     C     TIMSR         BEGSR
      *                                                                                       197767
     C     ST2           DOUGT     0
     C                   CALL      'CBTIME'
     C                   PARM                    DAYNOA
     C                   PARM                    STIME
     C                   PARM                    DFMT
     C                   MOVE      STIME         ST2
     C                   ENDDO
      *                                                                                       197767
     C                   ENDSR
      ****************************************************************                        197767
** CPY@
(c) Finastra International Limited 2001
** MSG
AFTER          H

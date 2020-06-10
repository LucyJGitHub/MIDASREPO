     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Set-up spool numbers file (specify group)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Report Control Facility Module                       *
      *                                                               *
      *  ZSFILE2 - Set Up Spool File Numbers File (Specify Group)     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  NOTE: This program is almost an exact duplicate of the pgm   *
      *        ZSFILE except that it allows the reporting group to    *
      *        be specified as a parameter. Therefore, any change to  *
      *        this program will probably also need to be applied to  *
      *        ZSFILE under the same change number.                   *
      *                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSC042             Date 16Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 TDA035             Date 02Apr04               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 216350  *CREATE    Date 18Mar03               *
      *                 xxxxxx             Date nnXxxnn               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CSC042 - COB performance fix. Stop the meaningless messages  *
      *           saying MAARCDPD has been changed to SEQONLY(*NO)    *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  216350 - Duplicate of ZSFILE with an extra parameter to      *
      *           define the reporting group when it differs from     *
      *           the logically calculated one.                       *
      *           - This program includes all the ZSFILE changes upto *
      *             and including SC189818.                           *
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
     F*   30    CHAIN FAIL TO MANDATORY OUTPUT INSTRUCTIONS
     F*   31    CHAIN FAIL TO MUSER
     F*   32    CHAIN FAIL TO REPORT REQUESTS
     F*   33    END OF RECORDS ON ARCHIVE CONTENTS PERM FOR REPORT
     F*   35    CHAIN FAIL TO SPOOL FILE NUMBERS
     F*
     F*   LR,U7&U8 SET ON IN EVENT OF DATABASE ERROR
     F*
     F****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
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
     D*
     D** Parameter list to pass to write to optical disk header record
     D*
     D IHEAD           DS
     D  HEADER                 1    198
     D  OUTPUT                 1      4
     D  REPORT                 5     14
     D  USERID                15     24
     D  JOBNAM                25     34
     D  JOBNBR                35     40
     D  SPLFNO                41     44
     D  RPTLVL                45     45
     D  ENTITY                46     48
     D  RSEQNO                49     53
     D  PRTFNM                54     63
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
     D RCFICD        E DS                  EXTNAME(SDRCFPD)
     D FCREPT        E DS                  EXTNAME(FCREPJW0)                                MD055265
     D FCRSFX        E DS                  EXTNAME(FCRSFJW0)                                MD055265
      *
     C     CSC042        IFNE      'Y'
     C                   MOVEA     CPY@          BIS@             80
     C                   MOVEL     'Y'           CSC042            1
     C                   CALL      'QCMDEXC'
     C                   PARM      #CMD(1)       PARM1            80
     C                   PARM      80            PARM2            15 5
     C                   OPEN      MAARCDPD
     C                   END
      *
      ** Accept Parameters
      *
     C     *ENTRY        PLIST
     C     RQSQ          PARM                    RSQNCE            5
     C                   PARM                    PRNAM            10
     C                   PARM                    ETTY
     C     SFNAME        PARM                    SFN              10
     C                   PARM                    SFNOP             6 0
     C                   PARM                    ERR               1
      *
      *
      ** Define Key List for chain to Permanent Archive Contents File
      *
     C     ARCP          KLIST
     C                   KFLD                    D5RNAM
     C                   KFLD                    PSQN
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
     C                   MOVE      ERR           LEVEL             1
      *
      * Initialise FCKEY with SFNAME value
      *
     C                   MOVE      SFNAME        FCKEY            10
     C                   MOVEL     SFNAME        S_NAME           10                        MD055265
      *
      ** Check what value should be recorded in the user data
      *
     C                   MOVEL     '*FIRST'      P@OPTN            7
      *
     C                   CALL      'AORCFR0'
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN                         I:Option
     C                   PARM                    RCFICD                         O:Format
      *
      ** Check return code
     C     P@RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   MOVEL     'SDRCFL0 '    DBFILE                         * DB ERR  005 *
     C                   Z-ADD     5             DBASE                          ***************
     C                   MOVEL     'ZSFILE2'     DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
     C                   MOVEL     S_NAME        SFNAME                                     MD055265
      ** Update or write to report requests file
     C                   EXSR      REPRQU
      *
      ** Update or write to spool files numbers file
     C                   EXSR      REST
      *
      ** Write header records to optical disk header file
     C                   EXSR      ODHDR
     C                   SETON                                        LR
      *
     C                   RETURN
      ********************************************************************
      /EJECT
      ********************************************************************
      ** Calls Subroutine DBERR
      ********************************************************************
      *
     C     REPRQU        BEGSR
      *
      *
      ** If sequence number is blank then a
      ** mandatory report is being processed
      *
     C     RQSQ          IFEQ      *BLANK
      *
      ** Obtain next sequence number from data area REPSEQ
      ** and update data area for next request
      *
     C     *DTAARA       DEFINE                  REPSEQ
     C     *LOCK         IN        REPSEQ
     C                   MOVE      SEQ           RQSQ
     C                   ADD       1             SEQ
     C                   OUT       REPSEQ
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
      ***If*the*phase*of*day*is*Close*of*Business*or*Next*Day*Set*Up***                       CCB020
      ***set*Report*Produced*in*COB*flag*to*'Y',*otherwise*set*********                       CCB020
      ***Report*Produced*in*Input*Cycle*flag*to*'Y'********************                       CCB020
      *
     C*********  PHASE     IFEQ 'C'                                                           CCB020
     C*********  PHASE     OREQ 'D'                                                           CCB020
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
      * Where a program name has been passed
      *
     C     PRNAM         IFNE      *BLANK
     C                   MOVEL     PRNAM         FCKEY
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
     C                   ELSE
      *
      ** Where printer files names are program name + suffix
      *
     C*****SFNAME        SETLL     FCREPTL1                                                 MD055265
      *
      ** Read previous record to the one to which the pointer is set,
      ** as Report Descriptions File is keyed on Report name
      ** and key used for SETLL is the printer file name
      *
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
     C                   ENDIF
      *
      ** If a record is found determine whether the first six
      ** characters of the report name match the first six
      ** characters of the spool file name
      *
     C     *IN32         IFEQ      '0'
     C                   MOVEL     DXRNAM        REPTR             6
     C                   MOVEL     SFNAME        SFNMR             6
     C     REPTR         COMP      SFNMR                              3232
     C                   END
      *
      ** If no matching record is found, attempt chain
      ** with the spool file name, as this may be a Midas/Q
      ** report for which the print file name will be the
      ** same as the Report Name
      *
     C     *IN32         IFEQ      '1'
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
     C                   MOVEL     'ZSFILE2'     DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
      ** Access the Mandatory Output Instructions File to determine
      ** if there are Mandatory Output Instructions for this report
      *
     C                   MOVE      *BLANKS       D2DLS1
     C                   MOVE      *BLANKS       D2DLS2
     C                   MOVE      *BLANKS       D2USRO
     C                   MOVE      *BLANKS       D2ARMF
     C                   MOVE      *BLANKS       D2AROD
     C*
     C     DXRNAM        CHAIN     FCMOUTL1                           30
      *
      *
      ** If a record is found then set User Id, Output Inst and
      ** Distribution Required as defined on the record
      **
      ** Else
      ** Set the default values for these fields:-
      ** Set User Id to be MIDAS, then determine default output Id
      ** and whether distribution is required.
      *
     C     *IN30         IFEQ      '0'
     C                   MOVE      D2DFTU        D5USRR
     C                   MOVE      D2DFTO        D5SOID
     C                   MOVE      D2DRQD        D5DRQD
     C                   ELSE
     C                   MOVE      *BLANKS       D5USRR
     C                   MOVEL     'MIDAS'       D5USRR
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
      *
      ** Set distribution for report request regardless of
      ** whether multibranching is on or not.
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
      *
     C                   END
      *
      ** If in a Multibranch system, then set the
      ** Default Branch for the requesting User
      *
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
     C                   MOVEL     'ZSFILE2'     DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
      *
      ** For all mandatory report requests,
      ** set up fields to write to report requests file
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
      ** In a Multi-branched system set up the level and entity fields
      ** to be the same for Single Branch environment.
      *
     C     ETTY          IFEQ      *BLANK
     C                   MOVE      *BLANKS       D5ETTY
     C                   MOVE      'S'           D5LVL
     C                   END
      *
     C     ETTY          IFNE      *BLANK
     C                   MOVE      'ALL'         D5ETTY
      *
      ** If Multibranching is on and Account Officer Level is not
      ** available then the Report level is 'B'; Else 'A'.
     C     MBIN          IFEQ      'Y'
      *
     C     DXALVL        IFEQ      'Y'
     C                   MOVE      'A'           D5LVL
     C                   ELSE
     C                   MOVE      'B'           D5LVL
     C                   END
      *
     C                   ELSE
     C                   MOVE      'A'           D5LVL
     C                   END
      *
     C                   END
      *
      ** In a Single branch system ensure that the
      ** level and entity fields are blank
      *
     C     MBIN          IFEQ      'N'
     C                   MOVE      *BLANKS       D5ETTY
     C                   MOVE      *BLANKS       D5LVL
     C                   END
      *
      ** Check if company level is specified
      *
     C     LEVEL         IFEQ      'C'
     C                   MOVE      'ALL'         D5ETTY
     C                   MOVE      'C'           D5LVL
     C                   END
      *
      ** Write record to file
      *
     C                   WRITE     @D5REI8
      *
      ** If Archiving has been requested, access the
      ** archive contents permanent file for the report details
      *
     C     D2ARMF        IFEQ      'Y'
     C     D2AROD        OREQ      'Y'
     C                   MOVE      '00'          PSQN
     C     ARCP          SETLL     MAARCPL2
     C     ARCP          READE     MAARCPL2                               33
      *
      * For each record which exists for the report,
      * write a record to the Daily Archive Contents File
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
      ** Else if the sequence number is not blank, then a
      ** requested report is being processed
      *
     C                   ELSE
      *
      ** Access the Report Requests file
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
     C                   MOVEL     'ZSFILE2'     DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
      ** Update the report requests record with the job details
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
      ** Calls Subroutine DBERR
      ********************************************************************
      *
     C     REST          BEGSR
      *
      ** Set up sequence number, print file name and entity
      ** for the write of a record to the spool file numbers file
      ** or chain to the spool file numbers file if this is a restart
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
     C                   KFLD                    D6SFNO
      *
     C                   MOVE      SFNO          D6SFNO
      *
     C     SFNOKY        CHAIN     FCSFNOL0                           35
      *
      ** Set up spool file number and status for the write to or
      ** update of a record on the spool file numbers file
      *
     C                   MOVE      'N'           D6PSTS
      *
      ** If a record was found on the spool file numbers file
      ** then update the file
      ** Else write a new record to the file
      *
     C     *IN35         IFEQ      '0'
     C                   UPDATE    @D6REJB
     C                   ELSE
     C*
     C** Access the report print file name file
     C** for the value of the audit file flag
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
     C                   MOVEL     'ZSFILE2'     DBPGM
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
      *
     C                   MOVE      DYAURP        D6AURP
     C                   WRITE     @D6REJB
     C                   END
      *
      ** Update user data with the entity.
     C                   EXSR      UDATA
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      ** S/R ODHDR - WRITE RECORDS TO OPTICAL DISK HEADER RECORDS FILE
      ** CALLED FROM MAIN PROCESSING
      ** CALLS MA0640 - CREATE HEADER RECORDS FOR OPTICAL DISK PROCESSING
      ********************************************************************
      *
     C     ODHDR         BEGSR
      *
      ** Write header records to optical disk header file if optical
      ** disk is requested.
      *
     C     D5AROD        IFEQ      'Y'
     C                   MOVE      *BLANKS       HEADER
     C                   MOVE      *BLANKS       @ERROR            1
     C                   MOVE      'OHDR'        OUTPUT
     C                   MOVE      D5RNAM        REPORT
      *
     C     D5USRO        IFEQ      *BLANKS
     C                   MOVE      D5JUSR        USERID
     C                   ELSE
     C                   MOVE      D5USRO        USERID
     C                   END
      *
     C                   MOVE      D5JBNM        JOBNAM
     C                   MOVE      D5JBNB        JOBNBR
     C                   MOVE      SFNO          SPLFNO
     C                   MOVE      D5LVL         RPTLVL
     C                   MOVE      D6XETY        ENTITY
     C                   MOVE      D5RQSQ        RSEQNO
     C                   MOVEL     D6RSFX        PRTFNM
     C                   CALL      'MA0640'
     C                   PARM                    HEADER
     C                   PARM                    @ERROR
      *
     C     @ERROR        IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R DBERR - TO PROCESS DATABASE ERRORS AND TERMINATE PROGRAM
     C*  Called from subroutines - REPRQU
     C*                          - REST
     C*  Calls subroutine - *PSSR
     C*
     C********************************************************************
     C*
     C     DBERR         BEGSR
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   RETURN
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S/R UDATA - UPDATE USER DATA                                 *
      *  CALLED FROM                                                  *
      *                                                               *
      *****************************************************************
     C     UDATA         BEGSR
      *
     C     D0UDTA        IFNE      *BLANK
     C     D0UDTA        ANDNE     'R'
      *
      ** Initialise user data field
     C                   MOVE      *BLANK        USRDTA           10
      *
      ** If entity is to be recorded in the user data
     C     D0UDTA        IFEQ      'E'
     C                   MOVEL     ETTY          USRDTA
     C     USRDTA        IFEQ      *BLANK
     C                   MOVEL     'SYSTEM'      USRDTA
     C                   END
     C                   END
      *
      ** Call FCC0320 to update the user data
     C                   CALL      'FCC0320'
     C                   PARM                    SFN
     C                   PARM                    USRDTA
     C                   PARM                    BERR              1
      *
      ** Error during FC0320 processing, run PSSR.
     C     BERR          IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   RETURN
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      ****************************************************************
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
(c) Finastra International Limited 2003
**                                                                                            CSC042
OVRDBF FILE(MAARCDPD) TOFILE(*FILE) OVRSCOPE(*JOB) SEQONLY(*NO)                               CSC042

     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*S*D ***RPGBASEMOD****************************************************   CAP002 MD024398
/*STD *  RPGSQLMOD                                                               MD024398
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *          MD055681
/*EXI *  TEXT('Midas AO Zone switchable features access object')
     F*****************************************************************
     F*                                                               *
     F*  Midas  ACCESS OBJECTS                                        *
     F*                                                               *
     F*     AOSARDR0 - READ/ACCESS TO SWITCHABLE FEATURES FILE        *
     F******AOSARDR0 - READ/ACCESS TO SAR DESCRIPTIIONS FILE          *
     F*                                                               *
     F*  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *   Last Amend No. MD055681         Date 31Jul20                *
      *   Prev Amend No. MD046248         Date 27Oct17                *
      *                  MD024398         Date 03Feb14                *
      * Midas Plus 1.4 ----------- Base ------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                  CSC007           Date 08May98                *
      *                  CAP002             Date 01May98              *
      *                  S01407           DATE 11MAR93                *
      *                  041840           DATE 02JUL92                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD024398 - API performance enhancements.                     *
      *           Cache valid features, and do not set on LR.         *
      *  CSC007 - Switchable Features Enhancements phase 2.           *
      *           Amendments to Switchable Features suite of          *
      *           programs to allow switching on via passwords.       *
      *           New code to coincide with these amendments are      *
      *           under CSC005.                                       *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*    S01407 - Switchability Enhancements                        *
     F*             Program recompiled over new Switchable Features   *
     F*             file which replaces the SARs decription file of   *
     F*             the same name SCSARDPD                            *
     F*    041840 - Because this access program has a special purpose *
     F*             (it is only used to check whether an SAR record      *
     F*             exists on the file), it has been made an exception   *
     F*             from the access program standards: it will now close *
     F*             the file after checking the record's existence.  The *
     F*             purpose is this is to prevent applications leaving   *
     F*             the file open and causing allocation problems.       *
     F*             (Note: this is when '*VERIFY' is used as the option.)*
     F*                                                                  *
     F********************************************************************
     F* ID F  C  H  L    FUNCTION OF INDICATORS                          *
     F*                                                                  *
     F*       01      OFF 1ST TIME ROUND                                 *
     F*       90      FILE ERROR                                         *
     F*       91      FILE OPEN ERROR                                    *
     F*       92      ERROR ON FILE CLOSE                                *
     F*       93      FILE EMPTY                                         *
     F*       94      EOF                                                *
     F*       95      NO RECORD FOUND                                    *
     F*       96      PARAMETER ERROR                                    *
     F*       97      IF NO SELECTION                                    *
     F*       98      ERROR ON PROGRAM CALL (SDFPSRB)                    *
     F*       LR      LAST RECORD                                        *
     F*                                                                  *
     F********************************************************************
      /EJECT
      ************************************************************
     F*CSARDL1IF**E           K        DISK                           UC  076385
     F*SCSARDL1* IF   E           K DISK                                         076385     MD055681
      **IN**-*SCSARDD0*SAR*Descriptions                                   S01407
      * IN  - @SARDL1  Switchable features                                S01407
      ************************************************************
      /EJECT
      ************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D********************************************************************
      ************************************************************
      /EJECT
      ************************************************************
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arr
     D*
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *                                                                                     MD024398
     D SFArray         S              6A   dim(9999)                                        MD024398
      *                                                                                     MD024398
     D APIMode         S              1A                                                    MD024398
     D P_RTCD          S             10A                                                    MD024398
     D P_OBJ           S             10A                                                    MD024398
     D P_LIB           S             10A                                                    MD024398
     D P_TYP           S              7A                                                    MD024398
     D P_MBR           S             10A                                                    MD024398
     D Ix              S              5S 0                                                  MD024398
     D Start           S              5S 0                                                  MD024398
     D Buffer          S          30000                                                     MD024398
     D BufLen          S              5S 0                                                  MD024398
      *
     D D@FMT         E DS                  EXTNAME(SCSARDPD)
      **SCSARDD0*-*SAR*Descriptions*record*format*data*structure          S01407
      * SCSARDD0 - Switchable features record format data structure       S01407
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
     I* External Data structure to hold the outgoing record format
     I* of the file.
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D                                     PREFIX(X)                                        MD055681
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@SARD            6            I:Key field
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
      *                                                                                     MD024398
      * If the call is from an API, we want to load all features into                       MD024398
      * an array and look up the requested feature in that array.                           MD024398
      * If the APIMode flag is Y then we have already loaded it, so                         MD024398
      * just go direct to the look up.                                                      MD024398
     C                   IF        P@OPTN = '*VERIFY' and                                   MD024398
     C                             APIMode = 'Y'                                            MD024398
     C                   GOTO      CheckF                                                   MD024398
     C                   ENDIF                                                              MD024398
      *                                                                                     MD024398
      * Check if the call is from an API. A data area in QTEMP is the                       MD024398
      * marker.                                                                             MD024398
     C                   IF        P@OPTN = '*VERIFY'                                       MD024398
                                                                                            MD024398
     C                   CALLB     'UTCHOBJEX'                                              MD024398
     C                   PARM      *BLANKS       P_RTCD                                     MD024398
     C                   PARM      'APFLAGQT'    P_OBJ                                      MD024398
     C                   PARM      'QTEMP'       P_LIB                                      MD024398
     C                   PARM      '*DTAARA'     P_TYP                                      MD024398
     C                   PARM      '*NONE'       P_MBR                                      MD024398
                                                                                            MD024398
     C                   IF        P_RTCD <> 'NotExist'                                     MD024398
      *                                                                                     MD024398
      * On first call, load the array from SCSARHTD (generated in CoB).                     MD024398
      * Set flag to bypass this on subsequent calls.                                        MD024398
     C                   EVAL      APIMode = 'Y'                                            MD024398
     C/EXEC SQL                                                                             MD024398
     C+ Select cast(SCCACH as char(30000))                                                  MD024398
     C+ into :Buffer                                                                        MD024398
     C+  from SCSARHTD                                                                      MD024398
     C/END-EXEC                                                                             MD024398
      *                                                                                     MD024398
     C                   IF        SQLCOD <> 0                                              MD024398
     C                   EVAL      P@RTCD = '*SQLERR'                                       MD024398
     C                   RETURN                                                             MD024398
     C                   ENDIF                                                              MD024398
      *                                                                                     MD024398
      * SCCACH contains all the valid features from SCSARDPD in a single                    MD024398
      * long string.  Extract this to the individual array elements.                        MD024398
     C                   EVAL      BufLen = %CheckR(' ':Buffer)                             MD024398
     C                   EVAL      Ix = 1                                                   MD024398
     C                   EVAL      Start = 1                                                MD024398
     C                   DOU       Ix > BufLen/6                                            MD024398
     C                   EVAL      SFArray(Ix) =%Subst(Buffer:Start:6)                      MD024398
     C                   EVAL      Ix =Ix + 1                                               MD024398
     C                   EVAL      Start = Start + 6                                        MD024398
     C                   ENDDO                                                              MD024398
      *                                                                                     MD024398
      * Lookup the feature in the array                                                     MD024398
     C     CheckF        TAG                                                                MD024398
     C                   EVAL      P@RTCD = *Blanks                                         MD024398
     C                   IF        %LookUp(P@SARD:SFArray:1:Ix) = 0                         MD024398
     C                   EVAL      P@RTCD = '*NRF'                                          MD024398
     C                   ENDIF                                                              MD024398
      *                                                                                     MD024398
      * Return (without setting on LR)                                                      MD024398
     C                   RETURN                                                             MD024398
     C                   ENDIF                                                              MD024398
     C                   ENDIF                                                              MD024398
      *
      * Access Option *SAME input
      *
     C     P@OPTN        IFEQ      '*SAME  '
     C********** *IN01     COMP '0'                      91               076385
     C                   GOTO      T@SKIP
     C                   END
      *
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
     C********** *IN01     IFEQ '0'                        IF 1 FIRST TIME076385
     C**********           SETON                     01      Set ind.     076385
     C**********           OPEN SCSARDL1               91    Open file    076385
     C********** *IN91     CABEQ'1'       T@SKIP         LR  Open error   076385
     C**********           END                             FI 1           076385
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PGM
     C**********           CLOSESCSARDL1               92    Close file   076385
     C********** *IN92     CABEQ'1'       T@SKIP         LR  Close error  076385
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C************LOVAL****SETLLSCSARDD0             9390    Set file     S01407
     C******LOVAL        SETLL     @SARDL1                            9390        Set S0140 MD055681
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C*********************READ SCSARDD0               9094  Read record  S01407
     C**********         READ      @SARDL1                              9094      ReadS0140 MD055681
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C************HIVAL****SETGTSCSARDD0               90    Set file     S01407
     C******HIVAL        SETGT     @SARDL1                              90        Set S0140 MD055681
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C*********************READPSCSARDD0               9094  Read record  S01407
     C**********         READP     @SARDL1                              9094      ReadS0140 MD055681
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACC
     C     P@OPTN        OREQ      '*VERIFY'                                    OR
     C***********P@SARD****CHAINSCSARDD0             9590    Get record   S01407
     C*****P@SARD        CHAIN     @SARDL1                            9590        Get S0140 MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = :P@SARD                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   SETOFF                                       9095                  MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   SETON                                          95                  MD055681
     C                   ENDIF                                                              MD055681
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055681
     C                   SETON                                          90                  MD055681
     C                   ENDIF                                                              MD055681
                                                                                            MD055681
     C     *IN95         CABEQ     '1'           T@SKIP                           No record fnd
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      'V'           MODE                                         CSC007
     C                   CALL      'SC3100'                                                   CSC007
      *  blank field                                                                          CSC007
     C                   PARM                    PASS             16                          CSC007
      *  Passed as blank from AOSARDR0, returns error message,                                CSC007
      *  or blanks if no error found.                                                         CSC007
     C                   PARM                    RTNCDE            7                          CSC007
      *  Switchable feature number                                                            CSC007
     C                   PARM                    P@SARD            6                          CSC007
      *  MODE: 'V'  Verify is only option from AOSARDR0                                       CSC007
     C                   PARM                    MODE              1                          CSC007
      *  blank field                                                                          CSC007
     C                   PARM                    CORE              2                          CSC007
     C     RTNCDE        IFNE      *BLANKS                                                    CSC007
     C                   MOVE      *ON           *IN95                                        CSC007
     C                   GOTO      T@SKIP                                                     CSC007
     C                   ENDIF                                                                CSC007
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter err
     C                   END                                                    FI 8
      *                                                                   041840
      * Caller requests record verification: in the special case of this  041840
      * access program, close the file.                                   041840
      *                                                                   041840
     C     P@OPTN        IFEQ      '*VERIFY'                                                   04184
     C**********           CLOSESCSARDL1               92          041840 076385
     C**********           SETOF                     01            041840 076385
     C                   SETON                                        LR                       04184
     C                   END                                                                   04184
      *
      * No record found or End of file - return error code :
      *          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *          ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        P@RTCD                         No Errors
     C   90              MOVE      '*ERROR '     P@RTCD                         File error
     C   91              MOVE      '*OPEN  '     P@RTCD                         Open error
     C   92              MOVE      '*CLOSE '     P@RTCD                         Close error
     C   93              MOVE      '*EMPTY '     P@RTCD                         Empty file
     C   94              MOVE      '*EOF   '     P@RTCD                         End of file
     C   95              MOVE      '*NRF   '     P@RTCD                         No record found
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection
     C   98              MOVE      '*CALL  '     P@RTCD                         Called Pgm.err.
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
     C   95              MOVE      'ACO1006'     P@MGID                           No record fnd
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1009'     P@MGID                           No selection
     C   98              MOVE      'ACO1010'     P@MGID                           Call error
     C                   CALLB     'ZASNMG'                                       <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program nm
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message fle
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Message dta
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message tpe
     C                   END                                                    FI 9
      *
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI
      *
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 13
     C     P@OPTN        ANDNE     '*FREE  '                                      AND
     C     P@RTCD        ANDNE     '*OPTION'                                      AND
     C                   eval      D@FMT = SCSARD                                           MD055681
     C                   MOVEL     D@FMT         P@FMT                          FI 13
     C                   END
      *
      * Return to caller :
      *
     C                   SETON                                        LR                       07638
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SCSARDPD  AOSARDR0  Switchable features
**CTDATA CPY@
(c) Finastra International Limited 2001

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Ind. mapping and upd of Equation P5 User Code File')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000084 - Equation Update of Industry Codes(P5 User Codes)  *
      *                                                               *
      *  Function:  This program Update Equation P5 User Codes File   *
      *                                                               *
      *  Called By: SDC000081 - Update Equation with consumer Banking *
      *                         Standing Data Details Control         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG14129           Date 13Jun07               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14129 - Industry codes do not show in Consumer-Universal  *
      *             customer screens                                  *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  U7+U8 -  Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SETPARM - Subroutine Populate input parameters for calling   *
      *           EQ API driver program H56H1R                        *
      *  *PSSR   - Program exception error routine                    *
      *  *INZSR  - Initialisation Subroutine                          *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.  Use      *
      *  RESET for subsequent passes.                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Valid Equation Message File
     FSDVALEQPD O    E             DISK    INFSR(*PSSR)
 
      ** Exception Equation Message File
     FSDEXCPEQPDO    E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
 
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Second DS for access programs, long data structure
     DDSSDY          E DS                  EXTNAME(DSSDY)
 
      ** External DS based on Midas users details file
     DSDUSER         E DS                  EXTNAME(MUSERDD)
 
      ** External DS based on Midas Local industry codes
     DBIMG           E DS                  EXTNAME(SDINDSPD)
     D                                     PREFIX(B_)
 
      ** External DS based on Midas Local industry codes
     DAIMG           E DS                  EXTNAME(SDINDSPD)
     D                                     PREFIX(A_)
 
      ** Data Structure for input parameter
     DPARM1            DS
     D SOURCE                  1      4
     D PFLNAME                 5     14
     D MBRNAME                25     34
     D TRGEVENT               35     35
     D BOFF                   53     56B 0
     D BLEN                   57     60B 0
     D AOFF                   69     72B 0
     D ALEN                   73     76B 0
     D EntryData             121  10121
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D OffSet          S              5P 0
     D DSAIM1          S            244A
     D @RPGM           S             10A
     D @BRNM           S              4A
     D @USID           S              4A
     D @WSID           S              4A
     D @JTT            S              1A
     D DSAIM           S           9999A
     D @RREC           S              1A
     D @RMES7          S             37A
     D AOW             S            740A
     D @ETK            S              4A
     D*@ETN*****       S              7S 0                                                  BUG14129
     D @ETN            S              7P 0                                                  BUG14129
     D @AEXT           S              1A
     D @AREC           S              1A
     D @RTNC           S             10A
     D @MSG            S            132A
     D @MSGID          S              7A
     D @MSGF           S             10A
     D P@APRC          S              7A
     D P@OPT           S              7A
     D @PRMEQ          S              1A                                                    BUG14129
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Recover Before & After Image
 
     C                   EVAL      OffSet = BOFF + 5
     C                   EVAL      BIMG = %SUBST(PARM1:OffSet:BLEN)
     C                   EVAL      OffSet = AOFF + 5
     C                   EVAL      AIMG = %SUBST(PARM1:OffSet:ALEN)
 
      ** Set Before image to blank if insert
 
     C                   IF        (TRGEVENT = '1')
     C                   EVAL      BIMG = *BLANKS
     C                   ENDIF
 
      ** Set After image to blank if Delete:
 
     C                   IF        (TRGEVENT = '2')
     C                   EVAL      AIMG = *BLANKS
     C                   ENDIF
 
      ** To map the EQ details of the transaction
 
     C                   CALL(E)   'SD000085'
     C                   PARM                    AIMG                           Input Parameter
     C                   PARM                    DSAIM1                         Output Parameter
 
      ** If Call ends in error
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'SD000085'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBPROC = 'SR/ MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Execute SR SETPARM to Populate the parameters for Equation API
 
     C                   EXSR      SETPARM
      ** Call Data Area Setup for equation                                                  BUG14129
     C                   Eval      @PRMEQ = *BLANKS                                         BUG14129
     C                   CALL(E)   'UTM83C'                                                 BUG14129
     C                   PARM                    @PRMEQ                                     BUG14129
                                                                                            BUG14129
     C                   IF        %ERROR                                                   BUG14129
     C     *LOCK         IN        LDA                                                      BUG14129
     C                   EVAL      DBFILE  = '*CALL  '                                      BUG14129
     C                   EVAL      DBKEY = 'UTM83C'                                         BUG14129
     C                   EVAL      DBASE = 013                                              BUG14129
     C                   EVAL      DBPROC = 'SR/MAIN'                                       BUG14129
     C                   OUT       LDA                                                      BUG14129
     C                   EXSR      *PSSR                                                    BUG14129
     C                   ENDIF                                                              BUG14129
 
      ** To execute the Industry Codes EQ API,Call the EQ API driver
      ** program
 
     C                   CALL(E)   'H56H1R'
     C                   PARM                    @RPGM                          Input Parameters
     C                   PARM                    @BRNM                          Input Parameters
     C                   PARM                    @USID                          Input Parameters
     C                   PARM                    @WSID                          Input Parameters
     C                   PARM                    @JTT                           Input Parameters
     C                   PARM                    DSAIM                          Input Parameters
 
     C**********         PARM                    @RREC                    Output Parameters BUG14129
     C                   PARM      *BLANKS       @RREC                                      BUG14129
     C                   PARM      *BLANKS       @RMES7                         Output Parameters
     C                   PARM      *BLANKS       AOW                            Output Parameters
     C                   PARM      *BLANKS       @ETK                           Output Parameters
     C                   PARM      *ZEROS        @ETN                           Output Parameters
 
     C                   PARM                    @AEXT                          Input Parameters
     C                   PARM                    @AREC                          Input Parameters
 
      ** If Call ends in an error
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'H56H1R'
     C                   EVAL      DBASE  = 002
     C                   EVAL      DBPROC = 'SR/ MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Output the record to valid message file if transaction was processed
      ** successfully
 
     C                   IF        @RREC = 'R'
     C                   EVAL      VESRC = SOURCE
     C                   EVAL      VEFLN = PFLNAME
     C                   EVAL      VEMBRN = MBRNAME
     C                   EVAL      VETRGE = TRGEVENT
     C                   EVAL      VEBOFF = BOFF
     C                   EVAL      VEBLEN = BLEN
     C                   EVAL      VEAOFF = AOFF
     C                   EVAL      VEALEN = ALEN
     C                   EVAL      VEETYD = EntryData
 
      ** Write to file SDVALEQPD
 
     C                   WRITE     SDVALEQD0
 
     C                   ENDIF
 
      ** Output a record to invalid message file if transaction failed
 
     C                   IF        @RREC = 'F'
     C                   EVAL      IESRC = SOURCE
     C                   EVAL      IEFLN = PFLNAME
     C                   EVAL      IEMBRN = MBRNAME
     C                   EVAL      IETRGE = TRGEVENT
     C                   EVAL      IEBOFF = BOFF
     C                   EVAL      IEBLEN = BLEN
     C                   EVAL      IEAOFF = AOFF
     C                   EVAL      IEALEN = ALEN
     C                   EVAL      IEETYD = EntryData
 
      ** Write to file SDEXCPEQPD
 
     C                   WRITE     SDEXCPEQD0
 
      ** To send message to the system operator
 
     C                   CALLB     'ZAMSGTOOPR'
 
     C                   PARM      *BLANKS       @RTNC                          Output Parameters
     C                   PARM      @RMES7        @MSG                           Input Parameters
     C                   PARM      *BLANKS       @MSGID                         Input Parameters
     C                   PARM      *BLANKS       @MSGF                          Input Parameters
 
     C                   DUMP
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      ************************************************************************
      /EJECT
      ************************************************************************
      *                                                                      *
      *   SETPARM - Subroutine to Populate input parameters for calling      *
      *             H56H1R                                                   *
      *                                                                      *
      *   Called by: Called in the Main Processing                           *
      *                                                                      *
      *   Calls: AOUSERR0                                                    *
      *                                                                      *
      ************************************************************************
 
     C     SETPARM       BEGSR
 
     C                   EVAL      @RPGM  = 'H48FRR'
 
      ** To find the branch of the user
     C                   CALL      'AOUSERR0'
 
     C                   PARM      *BLANKS       P@APRC                         Input Parameters
     C                   PARM      '*KEY'        P@OPT                          Input Parameters
     C                   PARM                    PSUser                         Input Parameters
     C     SDUSER        PARM      SDUSER        DSSDY                          Output Parameter
 
     C                   IF        P@APRC <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE  = 'MUSERDD'
     C                   EVAL      DBKEY   = P@OPT
     C                   EVAL      DBASE   = 003
     C                   EVAL      DBPROC  = 'SR/SETPARM '
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      @BRNM = DBRN
 
     C                   ENDIF
 
     C                   EVAL      @USID = %SUBST (PSUser:1:4)                  User-Id
     C                   EVAL      @WSID = 'MIDA'                               Wrkstn Identifier
 
      ** Calculate Function Types
 
      ** TRGEVENT='1'(Insert)
 
     C                   IF        TRGEVENT = '1'
     C                   EVAL      @JTT = 'A'
     C                   ENDIF
 
      ** TRGEVENT = '2' (Delete)
 
     C                   IF        TRGEVENT = '2'
     C**********         EVAL      @JTT = 'D'                                               BUG14129
     C                   EVAL      @JTT = 'M'                                               BUG14129
     C                   EVAL      %SUBST(DSAIM1:30:3) = B_AOLICD                           BUG14129
     C                   EVAL      %SUBST(DSAIM1:50:30) = B_AOLINA                          BUG14129
     C                   EVAL      %SUBST(DSAIM1:33:3) = '22A'                              BUG14129
     C                   ENDIF
 
      ** TRGEVENT = '3' (Change)
 
     C                   IF        TRGEVENT = '3'
     C                   EVAL      @JTT = 'M'
     C                   ENDIF
 
     C                   EVAL      DSAIM = DSAIM1
 
      ** Apply transaction during external input
 
     C                   EVAL      @AEXT = 'N'
 
      ** Apply transaction during recovery
 
     C                   EVAL      @AREC = 'N'
 
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
 
      ** Initialise Program and Module names
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1                          Input Parameter
 
      ** Define Local Data Area
 
     C     *DTAARA       DEFINE                  LDA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006

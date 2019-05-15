     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Currency Mapping and upd of Equation Currency File')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000088 - Equation Update of Currencies                     *
      *                                                               *
      *  Function:  This program Update Equation table for Currencies *
      *                                                               *
      *  Called By: SDC000081 - Update Equation with consumer Banking *
      *                         Standing Data Details Control         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG14132           Date 18Jun07               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14132 - New Currency codes do not show when               *
      *             opening  Consumer accounts                        *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8 -  Database Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SETPARM - Subroutine  to Populate the parameters for         *
      *            Equation API                                       *
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
 
      *  Valid Equation Message File
     FSDVALEQPD O    E             DISK    INFSR(*PSSR)
      *
      *  Exception Equation Message File
     FSDEXCPEQPDO    E             DISK    INFSR(*PSSR)
      *
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
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      *  Second DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      *  Data structure based on Midas users details file.
     D P@USER        E DS                  EXTNAME(MUSERDD)
      *
      *  Data structure based on Valid Equation Message File
     D VEDS          E DS                  EXTNAME(SDVALEQPD)
      *
      *  Data structure based on Invalid Equation Message File
     D IEDS          E DS                  EXTNAME(SDEXCPEQPD)
      *
      *  Before Image based on Midas SD Currency codes File
     D BIMG          E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(B_)
      *
      *  After  Image based on Midas SD Currency codes File
     D AIMG          E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(A_)
      *
      *  Data structure for input parameter PARM1
     DPARM1            DS
     D SOURCE                  1      4                                         Source
     D PFLNAME                 5     14                                         PF Name
     D MBRNAME                25     34                                         Member Name
     D TRGEVENT               35     35                                         Trigger Event
     D BOFF                   53     56B 0                                      Before Offset
     D BLEN                   57     60B 0                                      Before Length
     D AOFF                   69     72B 0                                      After Offset
     D ALEN                   73     76B 0                                      After Length
     D EntryData             121  10121                                         Entry Data
      *
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D OffSet          S              5P 0
     D DSAIM1          S            244
     D @RPGM           S             10
     D @BRNM           S              4
     D @USID           S              4
     D @WSID           S              4
     D @JTT            S              1
     D DSAIM           S           9999
     D @RREC           S              1
     D @RMES7          S             37
     D AOW             S            740
     D @ETK            S              4
     D*@ETN*****       S              7S 0                                                  BUG14132
     D @ETN            S              7P 0                                                  BUG14132
     D @AEXT           S              1
     D @AREC           S              1
     D @RTNC           S             10
     D @MSG            S            132
     D @MSGID          S              7
     D @MSGF           S             10
     D P@APRC          S              7
     D P@APOP          S              7
     D @PRMEQ          S              1A                                                    BUG14132
     D @ISOCF          S              3A                                                    BUG14132
     D WIND1           S              1A                                                    BUG14132
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automaticaLly: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      *            MAIN PROCEDURE                                     *
      *****************************************************************
 
      *
     C                   EVAL      WIND1 = 'N'                                              BUG14132
     C                   EVAL      OffSet = BOFF + 5
     C                   EVAL      BIMG = %SUBST(PARM1:OffSet:BLEN)
     C                   EVAL      OffSet = AOFF + 5
     C                   EVAL      AIMG = %SUBST(PARM1:OffSet:ALEN)
 
      *  Set Before image to blank if insert
     C                   IF        (TRGEVENT = '1')
     C**********         EVAL      BIMG = *BLANKS                                           BUG14132
     C                   EVAL      WIND1 = 'Y'                                              BUG14132
     C                   EVAL      TRGEVENT = '3'                                           BUG14132
     C                   EVAL      BIMG = AIMG                                              BUG14132
     C                   ENDIF
 
      *  Set After image to blank if Delete:
     C                   IF        (TRGEVENT = '2')
     C**********         EVAL      AIMG = *BLANKS                                           BUG14132
     C                   EVAL      AIMG = BIMG                                              BUG14132
     C                   ENDIF
 
      *  Call program SD000089 with below parameteres to map the EQ
      *  details of the transaction:
     C                   CALL      'SD000089'                           90
      *  Input Parameter as AIMG
     C                   PARM                    AIMG
      *  Input Parameter as BIMG
     C                   PARM                    BIMG
      *  Input Parameter as TRGEVENT
     C                   PARM                    TRGEVENT
      *  Output Parameter as DSAIM1
     C                   PARM                    DSAIM1
 
      *  Execute *PSSR if Error occured on Call
     C                   IF        *IN90 =  *ON
      *
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'SD000089'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBPROC = 'SR/ MAIN'
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *  Execute SR SETPARM to Populate the parameters for Equation API
     C                   EXSR      SETPARM
      * Setup Equation System Data Area                                                     BUG14132
     C                   Eval      @PRMEQ = *BLANKS                                         BUG14132
     C                   CALL(E)   'UTM83C'                                                 BUG14132
     C                   PARM                    @PRMEQ                                     BUG14132
                                                                                            BUG14132
     C                   IF        %ERROR                                                   BUG14132
     C     *LOCK         IN        LDA                                                      BUG14132
     C                   EVAL      DBFILE  = '*CALL  '                                      BUG14132
     C                   EVAL      DBKEY = 'UTM83C'                                         BUG14132
     C                   EVAL      DBASE = 013                                              BUG14132
     C                   EVAL      DBPROC = 'SR/MAIN'                                       BUG14132
     C                   OUT       LDA                                                      BUG14132
     C                   EXSR      *PSSR                                                    BUG14132
     C                   ENDIF                                                              BUG14132
 
      *  To execute the Location EQ API, call the EQ API program 'H56H1R'
     C                   CALL      'H56H1R'                             90
      *  Input Parameters
     C                   PARM                    @RPGM
     C                   PARM                    @BRNM
     C                   PARM                    @USID
     C                   PARM                    @WSID
     C                   PARM                    @JTT
     C                   PARM                    DSAIM
      *  Output Parameters
     C                   PARM                    @RREC
     C                   PARM      *BLANKS       @RMES7
     C                   PARM      *BLANKS       AOW
     C                   PARM      *BLANKS       @ETK
     C                   PARM      *ZEROS        @ETN
      *  Input Parameters
     C                   PARM                    @AEXT
     C                   PARM                    @AREC
      *
 
      *  If Call Ends in an ERROR, execute Subroutine *PSSR
     C                   IF        *IN90 = *ON
      *
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'H56H1R'
     C                   EVAL      DBASE  = 002
     C                   EVAL      DBPROC = 'SR/ MAIN'
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Output the record to valid message file if transaction was processed
      *  successfully
      *
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
      *
     C                   WRITE     SDVALEQD0
      *
     C                   ENDIF
      *
      *  Output a record to invalid message file if transaction failed
      *
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
      *
     C                   WRITE     SDEXCPEQD0
      *
      *  Call ZAMSGTOOPR with below parameters to send the message to the
      *  system operator.
     C                   CALLB     'ZAMSGTOOPR'
      *  Output Parameters
     C                   PARM      *Blanks       @RTNC
      *  Input Parameters
     C                   PARM      @RMES7        @MSG
     C                   PARM      *BLANKS       @MSGID
     C                   PARM      *BLANKS       @MSGF
      *
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SETPARM - Subroutine to Populate the parameters for Equation *
      *            API                                                *
      *                                                               *
      *  Called by: Called in the Main Processing                     *
      *                                                               *
      *  Calls: AOUSERR0                                              *
      *                                                               *
      *****************************************************************
      *
     C     SETPARM       BEGSR
      *
     C                   EVAL      @RPGM  = 'H48FRR'
 
      *  To find the branch of the user CALL AOUSERR0
     C                   CALL      'AOUSERR0'
      *  Input Parameters
     C                   PARM      *BLANK        P@APRC
     C                   PARM      '*KEY'        P@APOP
     C                   PARM                    PSUser
      *  Output Parameter
     C     P@USER        PARM      P@USER        DSSDY
      *
     C                   IF        P@APRC <> *Blanks
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE  =  'MUSERDD'
     C                   EVAL      DBKEY   =  PSUser
     C                   EVAL      DBASE   =  003
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C                   EVAL      @BRNM = DBRN
     C                   ENDIF
      *
      *  User-Id
     C                   EVAL      @USID = %SUBST (PSUser:1:4)
      *
      *  Workstation Identifier
     C                   EVAL      @WSID = 'MIDA'
      *
      *
      *  Calculate Function Types
      *
      *  TRGEVENT = '1' (Insert)
     C                   IF        TRGEVENT = '1'
     C                   EVAL      @JTT = 'A'
     C                   ENDIF
      *
      *  TRGEVENT = '2' (Delete)
     C                   IF        TRGEVENT = '2'
     C**********         EVAL      @JTT = 'D'                                               BUG14132
     C                   EVAL      @JTT = 'M'                                               BUG14132
     C                   MOVEL     B_A6ISON      @ISOCF                                     BUG14132
     C                   EVAL      %SUBST(DSAIM1:30:3) = @ISOCF                             BUG14132
     C                   EVAL      %SUBST(DSAIM1:33:3) = '22A'                              BUG14132
     C                   ENDIF
      *
      *  TRGEVENT = '3' (Change)
     C                   IF        TRGEVENT = '3'
     C                   EVAL      @JTT = 'M'
     C                   ENDIF
      ** Set up for Add in Equation                                                         BUG14132
     C                   IF        WIND1 = 'Y'                                              BUG14132
      *                                                                                     BUG14132
     C                   IF        A_A6DLCI = 'N'                                           BUG14132
     C                   EVAL      %SUBST(DSAIM1:33:3) = '21A'                              BUG14132
     C                   ELSE                                                               BUG14132
     C                   EVAL      %SUBST(DSAIM1:33:3) = *BLANKS                            BUG14132
     C                   ENDIF                                                              BUG14132
      *                                                                                     BUG14132
     C                   IF        A_A6MDIN = 'D'                                           BUG14132
     C                   EVAL      %SUBST(DSAIM1:36:3) = '11A'                              BUG14132
     C                   ELSE                                                               BUG14132
     C                   EVAL      %SUBST(DSAIM1:36:3) = *BLANKS                            BUG14132
     C                   ENDIF                                                              BUG14132
      *                                                                                     BUG14132
     C                   IF        A_A6RDFC = 'N'                                           BUG14132
     C                   EVAL      %SUBST(DSAIM1:39:3) = '16A'                              BUG14132
     C                   ELSE                                                               BUG14132
     C                   EVAL      %SUBST(DSAIM1:39:3) = *BLANKS                            BUG14132
     C                   ENDIF                                                              BUG14132
      *                                                                                     BUG14132
     C                   EVAL      %SUBST(DSAIM1:42:3) = '32A'                              BUG14132
      *                                                                                     BUG14132
     C                   ENDIF                                                              BUG14132
      *                                                                                     BUG14132
      *
     C                   EVAL      DSAIM = DSAIM1
      *
      *  Apply transaction during external input
     C                   EVAL      @AEXT = 'N'
 
      *  Apply transaction during recovery
     C                   EVAL      @AREC = 'N'
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
     C
     C                   ENDSR
      *
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
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C     *DTAARA       DEFINE                  LDA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006

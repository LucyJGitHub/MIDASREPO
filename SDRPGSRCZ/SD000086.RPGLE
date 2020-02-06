     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Equation Update of Collateral Locations')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000086 - Equation Update of Collateral Locations           *
      *                                                               *
      *  Function:  This program Update Equation table for Collateral *
      *             Locations                                         *
      *                                                               *
      *  Called By: SDC000081 - Update Equation with consumer Banking *
      *                         Standing Data Details Control         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BG12103            Date 08Nov06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG12103 - Equation update of collateral locations            *
      *            delete mode                                        *
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
      *  SETPARM - Subroutine Populate input parameters for calling   *
      *            EQ API driver program H56H1R                       *
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
      *
      *  Data Structure based on Midas user details Files
     DSDUSER         E DS                  EXTNAME(MUSERDD)
      *
      *  Before Image based on Midas SD currency code
     DBIMG           E DS                  EXTNAME(SDCOLOPD)
     D                                     PREFIX(B_)
      *
      *  After Image based on Midas SD currency code
     DAIMG           E DS                  EXTNAME(SDCOLOPD)
     D                                     PREFIX(A_)
      *
      *  Data Structure for Input Parameters
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
     D DSAIM1          S             56
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
     D*@ETN******      S              7S 0                                                   BG12103
     D @ETN            S              7P 0                                                   BG12103
     D @AEXT           S              1
     D @AREC           S              1
     D @RTNC           S             10
     D @MSG            S            132
     D @MSGID          S              7
     D @MSGF           S             10
     D @RUN            S              1
     D P@APRC          S              7
     D P@OPT           S              7
     D @PRMEQ          S              1A                                                     BG12103
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      *  MAIN PROCEDURE                                               *
      *****************************************************************
 
      *  Recover Before & After Image
     C                   EVAL      OffSet = BOFF + 5
     C                   EVAL      BIMG = %SUBST(PARM1:OffSet:BLEN)
     C                   EVAL      OffSet = AOFF + 5
     C                   EVAL      AIMG = %SUBST(PARM1:OffSet:ALEN)
 
      *  Set Before image to blank if insert
     C                   IF        (TRGEVENT = '1')
     C                   EVAL      BIMG = *BLANKS
     C                   ENDIF
 
      *  Set After image to blank if Delete:
     C                   IF        (TRGEVENT = '2')
     C**********         EVAL      AIMG = *BLANKS                                            BG12103
     C                   ENDIF
 
      *  Set Trigger Event to Delete if Update and RECI='R'                                  BG12103
     C                   IF        (TRGEVENT = '3') AND                                      BG12103
     C                             (A_CLRECI = 'R')                                          BG12103
     C                   EVAL      TRGEVENT = '2'                                            BG12103
     C                   ENDIF                                                               BG12103
                                                                                             BG12103
      *  Call program SD000087 to map EQ details of the transaction
     C                   CALL(E)   'SD000087'
      *  Input Parameter as AIMG
     C                   PARM                    AIMG
      *  Output Parameter as DSAIM1
     C                   PARM                    DSAIM1
 
      *  If Call Ends in an ERROR, execute SR *PSSR
     C                   IF        %ERROR
      *
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'SD000087'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBPROC = 'SR/ MAIN'
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *  Execute SR SETPARM to Populate the parameters for Equation API
     C                   EXSR      SETPARM
 
     C                   CALL      'UTM83C'                             90                   BG12103
     C                   PARM                    @PRMEQ                                      BG12103
      *  To execute the Location EQ API, call the EQ API program 'H56H1R'
     C                   CALL(E)   'H56H1R'
      *  Input Parameters
     C                   PARM                    @RPGM
     C                   PARM                    @BRNM
     C                   PARM                    @USID
     C                   PARM                    @WSID
     C                   PARM                    @JTT
     C                   PARM                    DSAIM
      *  Output Parameters
     C                   PARM                    @RREC
     C                   PARM      *Blanks       @RMES7
     C                   PARM      *Blanks       AOW
     C                   PARM      *Blanks       @ETK
     C                   PARM      *Zeros        @ETN
      *  Input Parameters
     C                   PARM                    @AEXT
     C                   PARM                    @AREC
      *
 
      *  If Call Ends in an ERROR, execute SR *PSSR
     C                   IF        %ERROR
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
 
     C                   WRITE     SDVALEQD0
 
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
 
     C                   WRITE     SDEXCPEQD0
      *
      *  To send message to the system operator CALLB ZAMSGTOOPR
     C                   CALLB     'ZAMSGTOOPR'
      *  Output Parameters
     C                   PARM      *Blanks       @RTNC
      *  Input Parameters
     C                   PARM      @RMES7        @MSG
     C                   PARM      *Blanks       @MSGID
     C                   PARM      *Blanks       @MSGF
 
     C                   DUMP
 
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      ************************************************************************
      /EJECT
      ************************************************************************
      *                                                                      *
      *  SETPARM - Subroutine Populate input parameters for calling H56H1R   *
      *                                                                      *
      *  Called by: Called in the Main Processing                            *
      *                                                                      *
      *  Calls: AOUSERR0                                                     *
      *                                                                      *
      ************************************************************************
      *
     C     SETPARM       BEGSR
      *
     C                   EVAL      @RPGM  = 'U11FRR'
 
      *   To find the branch of the user CALL AOUSERR0
     C                   CALL      'AOUSERR0'
      *  Input Parameters
     C                   PARM      *Blank        P@APRC
     C                   PARM      '*KEY'        P@OPT
     C                   PARM                    PSUser
      *  Output Parameter
     C     SDUSER        PARM      SDUSER        DSSDY
      *
     C                   IF        P@APRC <> *Blanks
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE  =  'MUSERDD'
     C                   EVAL      DBKEY   =  P@OPT
     C                   EVAL      DBASE   =  003
     C                   EVAL      DBPROC  =  'SR/ SETPARM '
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C                   EVAL      @BRNM = DBRN
      *
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
     C                   EVAL      @JTT = 'D'
     C                   ENDIF
      *
      *  TRGEVENT = '3' (Change)
     C                   IF        TRGEVENT = '3'
     C                   EVAL      @JTT = 'M'
     C                   ENDIF
      *
     C                   EVAL      DSAIM = DSAIM1
      *
      *  Apply transaction during external input
     C                   EVAL      @AEXT = *Blanks
      *  Apply transaction during recovery
     C                   EVAL      @AREC = *Blanks
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
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006

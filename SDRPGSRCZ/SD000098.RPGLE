     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Ind.Codes Mapping and Update of Eqn. Ind.Code File')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000098 - Equation Update of Industry Codes                 *
      *                                                               *
      *  Function:  This program reads the Midas Standing Data file   *
      *             for each record, maps the data to corresponding   *
      *             Equation fields and call the Equation API         *
      *                                                               *
      *  Called By: SDC000082 - Update Equation with Midas Standing   *
      *                         Data                                  *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG14620A          Date 31Aug07               *
      *                 CRE026C *CREATE    Date 30Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14620B - Consumer Banking Data Migration                  *
      *              Get the branch from SDBRCHPD                     *
      *  CRE026C - Consumer Banking Data Migration                    *
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
      *  SETPARM - Subroutine to populate input parameters for        *
      *            calling EQ API driver program H56H1R               *
      *  GETRCDLN- Subroutine to get record lengths of Transaction    *
      *            Data blocks.                                       *
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
 
      ** Midas SD Local Industry Codes
     FSDINDSPD  IF   E             DISK    INFSR(*PSSR)
      *                                                                                    BUG14620B
      ** Midas SD Branch code                                                              BUG14620B
     FSDBRCHPD  IF   E             DISK    INFSR(*PSSR)                                    BUG14620B
 
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
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS based on Midas users details file
     D*SDUSER***     E DS                  EXTNAME(MUSERDD)                                BUG14620B
 
      ** External DS based on Midas Local industry codes
     D AIMG          E DS                  EXTNAME(SDINDSPD)
 
      ** Input DS for Equation API callmeters
     D DSAIM           DS          9999
     D  VFAPP                         1
     D  VFWSD                         4
     D  VFRBR                         4
     D  VFBID                         5
     D  VFUID                         8
     D  VFTTP                         1
     D  VFBBN                         4
     D  VFKCD                         5
     D  VFINB                        12
     D  SPARE1                        5
     D  VFUFD                        30
     D  VFEB1                         1
     D  SPARE2                      163
     D  VFIND                         1
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D @RPGM           S             10A
     D @BRNM           S              4A
     D @USID           S              4A
     D @WSID           S              4A
     D @JTT            S              1A
     D @RREC           S              1A
     D @RMES7          S             37A
     D AOW             S            740A
     D @ETK            S              4A
     D @ETN            S              7P 0
     D @AEXT           S              1A
     D @AREC           S              1A
     D @RTNC           S             10A
     D @MSG            S            132A
     D @MSGID          S              7A
     D @MSGF           S             10A
     D @RUN            S              1A
     D P@APRC          S              7A
     D P@OPT           S              7A
     D @PRMEQ          S              1A
      *
     D SOURCE          S              4A                                        Source
     D PFLNAME         S             10A                                        PF Name
     D MBRNAME         S             10A                                        Member Name
     D TRGEVENT        S              1A                                        Trigger Event
     D BOFF            S              4B 0                                      Before Offset
     D BLEN            S              4B 0                                      Before Length
     D AOFF            S              4B 0                                      After Offset
     D ALEN            S              4B 0                                      After Length
     D EntryData       S          10000A                                        Entry Data
 
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
 
      ** Read record from file SDINDSPD
     C                   READ      SDINDSPD
 
     C                   DOW       NOT%EOF(SDINDSPD)
 
      ** Execute SR SETPARM to Populate the parameters for Equation API
     C                   EXSR      SETPARM
 
     C                   EVAL      @PRMEQ = *BLANKS
 
     C                   CALL(E)   'UTM83C'
     C                   PARM                    @PRMEQ
 
      ** If Call fails produce Database Error
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE  = '*CALL  '
     C                   EVAL      DBKEY = 'UTM83C'
     C                   EVAL      DBASE = 014
     C                   EVAL      DBPROC = 'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** To execute the Industry Codes EQ API, call the EQ API program 'H56H1R'
     C                   CALL(E)   'H56H1R'
      ** Input Parameters
     C                   PARM                    @RPGM
     C                   PARM                    @BRNM
     C                   PARM                    @USID
     C                   PARM                    @WSID
     C                   PARM                    @JTT
     C                   PARM                    DSAIM
      ** Output Parameters
     C                   PARM      *BLANKS       @RREC
     C                   PARM      *BLANKS       @RMES7
     C                   PARM      *BLANKS       AOW
     C                   PARM      *BLANKS       @ETK
     C                   PARM      *ZEROS        @ETN
      ** Input Parameters
     C                   PARM                    @AEXT
     C                   PARM                    @AREC
 
      ** If Call Ends in an ERROR, execute SR *PSSR
     C                   IF        %ERROR
      *
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'H56H1R'
     C                   EVAL      DBASE  = 005
     C                   EVAL      DBPROC = 'SR/MAIN'
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set values for work variable to populate the Equation message file fields
     C                   EVAL      SOURCE   = 'INDS'
     C                   EVAL      PFLNAME  = 'SDINDSPD'
     C                   EVAL      MBRNAME  = *BLANKS
     C                   EVAL      TRGEVENT = '1'
     C                   EVAL      BOFF     = 117
     C                   MOVEL     PFLNAME       FileName
 
      ** Get the Record Length of the File
 
     C                   EXSR      GETRCDLN
 
     C                   EVAL      BLEN = RecordLen
     C                   EVAL      AOFF = 118 + RecordLen
     C                   EVAL      ALEN = RecordLen
     C                   EVAL      %SUBST(EntryData:RecordLen+1) = AIMG
 
      ** Output the record to valid message file if transaction was processed
      ** successfully
     C                   IF        @RREC  = 'R'
     C                   EVAL      VESRC  = SOURCE
     C                   EVAL      VEFLN  = PFLNAME
     C                   EVAL      VEMBRN = MBRNAME
     C                   EVAL      VETRGE = TRGEVENT
     C                   EVAL      VEBOFF = BOFF
     C                   EVAL      VEBLEN = BLEN
     C                   EVAL      VEAOFF = AOFF
     C                   EVAL      VEALEN = ALEN
     C                   EVAL      VEETYD = EntryData
 
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
 
     C                   WRITE     SDEXCPEQD0
 
      ** To send message to the system operator CALLB ZAMSGTOOPR
     C                   CALLB     'ZAMSGTOOPR'
      ** Output Parameters
     C                   PARM      *BLANKS       @RTNC
      ** Input Parameters
     C                   PARM      @RMES7        @MSG
     C                   PARM      *BLANKS       @MSGID
     C                   PARM      *BLANKS       @MSGF
 
     C                   DUMP
 
     C                   ENDIF
 
      ** Read the next record of SDINDSPD file
     C                   READ      SDINDSPD
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SETPARM - Subroutine to populate input parameters for        *
      *            calling EQ API driver program H56H1R               *
      *                                                               *
      *  Called by: Called in the Main Processing                     *
      *                                                               *
      *  Calls: AOUSERR0                                              *
      *                                                               *
      *****************************************************************
 
     C     SETPARM       BEGSR
 
      ** Application code
     C                   EVAL      VFAPP  = 'D'
      ** Workstation identifier
     C                   EVAL      VFWSD  = 'MIDA'
 
      ***To*find the branch of the user CALL AOUSERR0                                      BUG14620B
     C**********         CALL      'AOUSERR0'                                              BUG14620B
      ***Input*Parameters                                                                  BUG14620B
     C**********         PARM      *BLANKS       P@APRC                                    BUG14620B
     C**********         PARM      '*KEY'        P@OPT                                     BUG14620B
     C**********         PARM                    PSUser                                    BUG14620B
      ***Output*Parameter                                                                  BUG14620B
     C*****SDUSER        PARM      SDUSER        DSSDY                                     BUG14620B
      *
     C**********         IF        P@APRC <> *BLANKS                                       BUG14620B
      *
     C******LOCK         IN        LDA                                                     BUG14620B
     C**********         EVAL      DBFILE  =  'MUSERDD'                                    BUG14620B
     C**********         EVAL      DBKEY   =  P@OPT                                        BUG14620B
     C**********         EVAL      DBASE   =  006                                          BUG14620B
     C**********         EVAL      DBPROC  =  'SR/SETPARM'                                 BUG14620B
     C**********         OUT       LDA                                                     BUG14620B
      *
     C**********         EXSR      *PSSR                                                   BUG14620B
      *
     C**********         ENDIF                                                             BUG14620B
 
      ** Input Branch Number
     C**********         EVAL      VFRBR = DBRN                                            BUG14620B
     C                   EVAL      VFRBR = A8BRCD                                          BUG14620B
 
      ** Transaction Identifier
     C                   EVAL      VFBID = PSUser
 
      ** User Identifier
     C                   EVAL      VFUID = PSUser
 
      ** Parameter type - B
     C                   EVAL      VFTTP = 'B'
 
      ** Reserve number 0000 or Language Code
     C                   EVAL      VFBBN = '0000'
 
      ** Key Code P5/Industry code
     C                   EVAL      VFKCD = 'P5' + AOLICD
 
      ** 4x3 byte indicator maintenance
     C                   EVAL      VFINB  = *BLANKS
 
      ** Spare
     C                   EVAL      SPARE1 = *BLANKS
 
      ** User field description
     C                   EVAL      VFUFD  = AOLINA
 
      ** End of block code 1
     C                   EVAL      VFEB1  = X'3B'
 
      ** SPARE
     C                   EVAL      SPARE2 = *BLANKS
 
      ** Indicator
     C                   EVAL      VFIND  = *BLANKS
 
      ** Function identifier
     C                   EVAL      @RPGM  = 'H48FRR '
 
      **
     C**********         EVAL      @BRNM  = DBRN                                           BUG14620B
     C                   EVAL      @BRNM  = A8BRCD                                         BUG14620B
 
      ** User Id
     C                   EVAL      @USID  = %SUBST(PSUser:1:4)
 
      ** Workstation identifier
     C                   EVAL      @WSID  = 'MIDA'
 
      ** Calculate Function Type :-
     C                   EVAL      @JTT   = 'A'
 
      ** Apply transaction during external input
     C                   EVAL      @AEXT  = *BLANKS
 
      ** Apply transaction during recovery
     C                   EVAL      @AREC  = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GETRCDLN- Subroutine to Get Record Lengths of Transaction    *
      *            Data Blocks                                        *
      *                                                               *
      *  Called by: Called in the Main Processing                     *
      *                                                               *
      *  Calls: UTGETRCDLN                                            *
      *                                                               *
      *****************************************************************
     C     GETRCDLN      BEGSR
 
     C                   CALLB     'UTGETRCDLN'
 
      ** Return code
     C                   PARM                    ReturnCode       10
      ** Record length
     C                   PARM      *ZEROS        RecordLen         5 0
 
      ** File name
     C                   PARM                    FileName         10
 
      ** File library
     C                   PARM      '*LIBL     '  FileLib          10
 
      ** If file not found (or any other error) shut down the program
     C     ReturnCode    IFNE      *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
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
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *
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
     C     *INZSR        BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Read Branch code                                                                  BUG14620B
     C                   READ      SDBRCHPD                                                BUG14620B
                                                                                           BUG14620B
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2007

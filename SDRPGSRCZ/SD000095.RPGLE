     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Location Mapping & Update of Equation Region File')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000095 - Equation Update of Locations                      *
      *                                                               *
      *  Function:  This program reads the Midas Standing Data file   *
      *             for each record, maps the data to corresponding   *
      *             Equation file fields and call the Equation API    *
      *                                                               *
      *  Called By: SDC000082 - Update Equation with Midas Standing   *
      *                         Data                                  *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG14620D          Date 04Sep07               *
      *                 BUG14620B          Date 31Aug07               *
      *                 BUG14620A          Date 23Aug07               *
      *                 CRE026C *CREATE    Date 02May07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14620D - Consumer Banking Data Migration                  *
      *              Validate Holiday when date is rundate or         *
      *              next working date. Set tran type to blank        *
      *  BUG14620B - Consumer Banking Data Migration                  *
      *              Get the branch from SDBRCHPD                     *
      *  BUG14620A - Migration Program Dumps                          *
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
 
      ** Midas SD Location codes
     FSDLOCNPD  IF   E             DISK    INFSR(*PSSR)
      *                                                                                    BUG14620B
      ** Midas SD Branch code                                                              BUG14620B
     FSDBRCHPD  IF   E             DISK    INFSR(*PSSR)                                    BUG14620B
      *
      ** Valid Equation Message File
     FSDVALEQPD O    E             DISK    INFSR(*PSSR)
      *
      ** Exception Equation Message File
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
      *                                                                                    BUG14620A
     D PMODEINIT       S              1                                                    BUG14620A
 
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
     D AIMG          E DS                  EXTNAME(SDLOCNPD)
 
      ** Input DS for Equation API call
     D DSAIM           DS          9999
     D  GZWSID                        4
     D  GZDIM                         2  0
     D  GZTIM                         6  0
     D  GZSEQ                         7P 0
     D  GZIMG                         1
     D  GZREG                         3
     D  GZRED                        35
 
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
 
      ** Read record from file SDLOCNPD
     C                   READ      SDLOCNPD
 
     C                   DOW       NOT%EOF(SDLOCNPD)
     C                   IF        DVLCCD <> '***'                                         BUG14620A
 
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
     C                   EVAL      DBASE = 015
     C                   EVAL      DBPROC = 'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** To execute the Location EQ API, call the EQ API program 'H56H1R'
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
 
      ** If Call Ends in an ERROR, Execute Subroutine *PSSR
     C                   IF        %ERROR
 
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'H56H1R'
     C                   EVAL      DBASE  = 007
     C                   EVAL      DBPROC = 'SR/MAIN'
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set work variable for the Equation message file fields
 
     C                   EVAL      SOURCE   = 'LOCN'
     C                   EVAL      PFLNAME  = 'SDLOCNPD'
     C                   EVAL      MBRNAME  = *BLANKS
     C     *LOCK         IN        PMODEINIT                                               BUG14620A
     C                   IF        PMODEINIT = '1'                                         BUG14620A
     C                   EVAL      TRGEVENT = '1'
     C                   ELSE                                                              BUG14620A
     C                   EVAL      TRGEVENT = '3'                                          BUG14620A
     C                   ENDIF                                                             BUG14620A
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
      *
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
      *
      ** Output a record to invalid message file if transaction failed
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
 
      ** Read the next record of SDLOCNPD file
     C                   ENDIF                                                             BUG14620A
     C                   READ      SDLOCNPD
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
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
 
      ** Workstation id
     C                   EVAL      GZWSID = 'MIDA'
      ** Day in month
     C                   EVAL      GZDIM  = *ZEROS
      ** Time; hhmmss
     C                   EVAL      GZTIM  = *ZEROS
      ** Sequence number
     C                   EVAL      GZSEQ  = *ZEROS
     C                   EVAL      GZIMG  = *BLANKS
      ** Location Code
     C                   EVAL      GZREG  = DVLCCD
      ** Location Name
     C                   EVAL      GZRED  = DVLCNM
      ** Function identifier
     C                   EVAL      @RPGM  = 'T42FRR'
 
      ***To*find the branch of the user CALL AOUSERR0                                      BUG14620B
     C**********         CALL      'AOUSERR0'                                              BUG14620B
      ***Input*Parameters                                                                  BUG14620B
     C**********         PARM      *BLANKS       P@APRC                                    BUG14620B
     C**********         PARM      '*KEY'        P@OPT                                     BUG14620B
     C**********         PARM                    PSUser                                    BUG14620B
      ***Output*Parameter                                                                  BUG14620B
     C*****SDUSER        PARM      SDUSER        DSSDY                                     BUG14620B
 
     C**********         IF        P@APRC <> *Blanks                                       BUG14620B
 
     C******LOCK         IN        LDA                                                     BUG14620B
     C**********         EVAL      DBFILE  =  'MUSERDD'                                    BUG14620B
     C**********         EVAL      DBKEY   =  P@OPT                                        BUG14620B
     C**********         EVAL      DBASE   =  008                                          BUG14620B
     C**********         EVAL      DBPROC  =  'SR/SETPARM'                                 BUG14620B
     C**********         OUT       LDA                                                     BUG14620B
 
     C**********         EXSR      *PSSR                                                   BUG14620B
 
     C**********         ELSE                                                              BUG14620B
 
     C**********         EVAL      @BRNM = DBRN                                            BUG14620B
     C                   EVAL      @BRNM = A8BRCD                                          BUG14620B
 
     C**********         ENDIF                                                             BUG14620B
 
      ** User-Id
     C                   EVAL      @USID = %SUBST(PSUser:1:4)
 
      ** Workstation Identifier
     C                   EVAL      @WSID = 'MIDA'
 
      ** Calculate Function Types
 
     C**********         IF        PMODEINIT = '1'                               BUG14620A BUG14620D
     C**********         EVAL      @JTT = 'A'                                              BUG14620D
     C**********         ELSE                                                    BUG14620A BUG14620D
     C**********         EVAL      @JTT = 'M'                                    BUG14620A BUG14620D
     C**********         ENDIF                                                   BUG14620A BUG14620D
     C                   EVAL      @JTT = ' '                                              BUG14620D
 
      ** Apply transaction during external input
     C                   EVAL      @AEXT = *BLANKS
 
      ** Apply transaction during recovery
     C                   EVAL      @AREC = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GETRCDLN - Get Record Lengths of Transaction Data Blocks     *
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
     C     *PSSR         BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
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
     C     *DTAARA       DEFINE                  PMODEINIT                                 BUG14620A
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

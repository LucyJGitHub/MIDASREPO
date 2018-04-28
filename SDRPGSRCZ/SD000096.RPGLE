     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Spot Rate Mapping and Upd of Equ Spot Rate File')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000096 - Equation Update of Spot Rates                     *
      *                                                               *
      *  Function:  This program reads the Midas Standing Data file   *
      *             for each record, maps the data to corresponding   *
      *             Equation file fields and call the Equation API    *
      *                                                               *
      *  Called By: SDC000082 - Update Equation with Midas Standing   *
      *                         Data                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG14620B          Date 31Aug07               *
      *  Prev Amend No. CRE026C *CREATE    Date 30Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG14620B - Consumer Banking Data Migration                  *
      *              Get the branch from SDBRCHPD                     *
      *  CRE026C - Consumer Banking Data Migration                    *
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
      *  SETPARM - Subroutine to populate input parameters for        *
      *            calling EQ API driver program H56H1R               *
      *  GETRCDLN- Subroutine to get Record Lengths of Transaction    *
      *            Data Blocks                                        *
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
 
      ** Midas SD Currency codes File
     FSDCURRPD  IF   E             DISK    INFSR(*PSSR)
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
 
      ** Data Structure based on Midas user details Files
     D*SDUSER***     E DS                  EXTNAME(MUSERDD)                                BUG14620B
 
      ** After Image based on Midas SD currency code
     D AIMG          E DS                  EXTNAME(SDCURRPD)
      *
      ** Input DS for Equation API call
     DDSAIM            DS          9999
     D GZWSID                         4A
     D GZDIM                          2  0
     D GZTIM                          6  0
     D GZSEQ                          7P 0
     D GZIMG                          1A
     D GZCCY                          3A
     D GZSPT                         13P 7
     D GZUSR                         13P 7
     D GZEXR                         13P 7
     D GZDATC                         5A
     D GZDTE                          7  0
     D GZHDLM                         7  0
     D GZHTIM                         6  0
     D GZSPE                         15P 9
     D GZUSE                         15P 9
     D GZEXT                         15P 9
     D GZNSP                         15P 9
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D OffSet          S              5P 0
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
      *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      *  MAIN PROCEDURE                                               *
      *****************************************************************
 
      ** Read record from file SDCURRPD
     C                   READ      SDCURRPD
 
     C                   DOW       NOT%EOF(SDCURRPD)
 
      ** Execute Subroutine SETPARM to Populate the parameters for Equation API
     C                   EXSR      SETPARM
 
     C                   EVAL      @PRMEQ = *BLANKS
 
     C                   CALL(E)   'UTM83C'
     C                   PARM                    @PRMEQ
 
      ** If Call fails produce Database Error
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE  = '*CALL  '
     C                   EVAL      DBKEY = 'UTM83C'
     C                   EVAL      DBASE = 016
     C                   EVAL      DBPROC = 'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** To execute the Spot Rate EQ API, call the EQ API program 'H56H1R'
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
      *
      ** If Call Ends in an ERROR, Execute Subroutine *PSSR
     C                   IF        %ERROR
 
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'H56H1R'
     C                   EVAL      DBASE  = 009
     C                   EVAL      DBPROC = 'SR/MAIN'
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set values for work variable to populate the Equation message file fields
 
     C                   EVAL      SOURCE = 'CURR'
     C                   EVAL      PFLNAME = 'SDCURRPD'
     C                   EVAL      MBRNAME  = *BLANKS
     C                   EVAL      TRGEVENT = '1'
     C                   EVAL      BOFF = 117
     C                   MOVEL     PFLNAME       FileName
 
      ** Get the Record Length of the File
     C                   EXSR      GETRCDLN
 
     C                   EVAL      BLEN = RecordLen
     C                   EVAL      AOFF = 118 + RecordLen
     C                   EVAL      ALEN = RecordLen
     C                   EVAL      %SUBST(EntryData:RecordLen+1) = AIMG
 
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
 
      ** Read the next record of SDCURRPD file
     C                   READ      SDCURRPD
 
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
      *
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
      ** Currency mnemonic
     C                   EVAL      GZCCY  = A6CYCD
      ** Obsolete - use GZSPE
     C                   EVAL      GZSPT  = *ZEROS
      ** Obsolete - use GZUSE
     C                   EVAL      GZUSR  = *ZEROS
      ** Obsolete - use GZEXT
     C                   EVAL      GZEXR  = *ZEROS
      ** Date code
     C                   EVAL      GZDATC = *BLANKS
      ** Database date; cyymm
     C                   EVAL      GZDTE  = *ZEROS
      ** Date last maintained
     C                   EVAL      GZHDLM = *ZEROS
      ** Time written to HE f
     C                   EVAL      GZHTIM = *ZEROS
      ** Spot rate
     C                   EVAL      GZSPE  = A6SPRT
      ** User rate
     C                   EVAL      GZUSE  = *ZEROS
      ** Premium/Discount
     C                   EVAL      GZEXT  = *ZEROS
      ** Next day's spot rate
     C                   EVAL      GZNSP  = *ZEROS
 
      ** Function identifier
     C                   EVAL      @RPGM  = 'H82LRR'
 
      ***To*find the branch of the user CALL AOUSERR0                                      BUG14620B
     C**********         CALL      'AOUSERR0'                                              BUG14620B
      ***Input*Parameters                                                                  BUG14620B
     C**********         PARM      *BLANKS       P@APRC                                    BUG14620B
     C**********         PARM      '*KEY'        P@OPT                                     BUG14620B
     C**********         PARM                    PSUser                                    BUG14620B
      ***Output*Parameter                                                                  BUG14620B
     C*****SDUSER        PARM      SDUSER        DSSDY                                     BUG14620B
 
     C**********         IF        P@APRC <> *BLANKS                                       BUG14620B
 
     C******LOCK         IN        LDA                                                     BUG14620B
     C**********         EVAL      DBFILE  =  'MUSERDD'                                    BUG14620B
     C**********         EVAL      DBKEY   =  P@OPT                                        BUG14620B
     C**********         EVAL      DBASE   =  010                                          BUG14620B
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
 
     C                   EVAL      @JTT = 'M'
 
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
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
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
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Read Branch code                                                                  BUG14620B
     C                   READ      SDBRCHPD                                                BUG14620B
                                                                                           BUG14620B
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2007

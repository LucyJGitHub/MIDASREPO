     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Holiday Map and upd of Eq. Curr.and Br.Calenders')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000097 - Holiday Mapping and Update of Equation Currency   *
      *             and Branch Calendars                              *
      *                                                               *
      *  Function:  This program reads the Midas Standing Data file   *
      *             for each record and calls the program SD000056    *
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
      *                 BUG14620A          Date 23Aug07               *
      *                 CRE026C *CREATE    Date 30Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14620D - Consumer Banking Data Migration                  *
      *              Validate Holiday when date is rundate or         *
      *              next working date. Set tran type to blank        *
      *  BUG14620A - Migration Program Dumps                          *
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
      *  *PSSR   - Program exception error routine                    *
      *  *INZSR  - Initialisation Subroutine                          *
      *  GETRCDLN- Subroutine to get Record Lengths of Transaction    *
      *            Data Blocks                                        *
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
 
      ** Midas SD Holidays
     FSDHOLPD   IF   E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                               BUG14620A
                                                                                           BUG14620A
     D DSFDY         E DS                  EXTNAME(DSFDY)                                  BUG14620A
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
 
      ** After Image based on Midas SD Holidays file
     DAIMG           E DS                  EXTNAME(SDHOLPD)
 
      ** Data Structure for Output parameter
     DPARM1            DS
     D SOURCE                  1      4                                         Source
     D PFLNAME                 5     14                                         PF Name
     D MBRNAME                25     34                                         Member Name
     D TRGEVENT               35     35                                         Trigger Event
     D BOFF                   53     56B 0                                      Before Offset
     D BLEN                   57     60B 0                                      Before Length
     D AOFF                   69     72B 0                                      After Offset
     D ALEN                   73     76B 0                                      After Length
     D EntryData             121   9999A                                        Entry Data
      *                                                                                    BUG14620A
     DWDATE            DS                                                                  BUG14620A
     D WDDMMM                  1      5                                                    BUG14620A
     D WYY                     6      7S 0                                                 BUG14620A
      *                                                                                    BUG14620A
     DWYearHoll        DS                                                                  BUG14620A
     D WccHol                  1      2S 0                                                 BUG14620A
     D WyyHol                  3      4S 0                                                 BUG14620A
      *                                                                                    BUG14620A
     DWYearBank        DS                                                                  BUG14620A
     D WccBank                 1      2S 0                                                 BUG14620A
     D Wyybank                 3      4S 0                                                 BUG14620A
      *                                                                                    BUG14620A
 
     D PMODEINIT       S              1                                                    BUG14620A
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D ReturnCode      S             10A
     D RecordLen       S              5  0
     D FileName        S             10A
     D FileLib         S             10A
 
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
 
     C                   CALL      'AOBANKR0'                                              BUG14620A
     C                   PARM      '*DBERR '     @RTCD             7                       BUG14620A
     C                   PARM      '*FIRST '     @OPTN             7                       BUG14620A
     C     SDBANK        PARM      SDBANK        DSFDY                                     BUG14620A
     C**                                                                                   BUG14620A
     C     @RTCD         IFNE      *BLANKS                                                 BUG14620A
      *                                                                                    BUG14620A
     C     *LOCK         IN        LDA                                                     BUG14620A
     C                   EVAL      DBFILE =  'SDBANKPD'                                    BUG14620A
     C                   EVAL      DBKEY  =  @OPTN                                         BUG14620A
     C                   EVAL      DBPGM  =  PSProcPgm                                     BUG14620A
     C                   EVAL      DBASE  =  006                                           BUG14620A
     C                   EVAL      DBMOD  =  PSProcMod                                     BUG14620A
     C                   EVAL      DBPROC =  'SR/*INZSR '                                  BUG14620A
     C                   EXSR      *PSSR                                                   BUG14620A
     C                   OUT       LDA                                                     BUG14620A
      *                                                                                    BUG14620A
     C                   ENDIF                                                             BUG14620A
      *                                                                                    BUG14620A
      ** Read record from file SDHOLPD
     C                   READ      SDHOLPD
 
     C                   DOW       NOT%EOF(SDHOLPD)
 
      ** Populate the parameters for Program SD000056
     C                   EVAL      SOURCE = 'HOLD'
     C                   EVAL      PFLNAME = 'SDHOLPD'
     C                   EVAL      MBRNAME  = *BLANKS
     C     *LOCK         IN        PMODEINIT                                               BUG14620A
     C                   IF        PMODEINIT = '1'                                         BUG14620A
     C                   EVAL      TRGEVENT = '1'
     C                   ELSE                                                              BUG14620A
     C                   EVAL      TRGEVENT = '3'                                          BUG14620A
     C                   ENDIF                                                             BUG14620A
     C                   EVAL      BOFF = 117
     C                   MOVEL     PFLNAME       FileName
 
      ** Execute Subroutine GETRCDLEN to get the Record length
 
     C                   EXSR      GETRCDLN
 
     C                   EVAL      BLEN = RecordLen
     C                   EVAL      AOFF = 118 + RecordLen
     C                   EVAL      ALEN = RecordLen
     C                   EVAL      %SUBST(PARM1:AOFF+5)= AIMG
 
     C                   Eval      WDate = BJMRDT                                          BUG14620A
     C                   Eval      WyearHoll = DGYRNB                                      BUG14620A
     C                   Eval      WyyBank = Wyy                                           BUG14620A
     C                   IF        WyyBank < 40                                            BUG14620A
     C                   EVAL      WccBank = 20                                            BUG14620A
     C                   ELSE                                                              BUG14620A
     C                   EVAL      WccBank = 19                                            BUG14620A
     C                   ENDIF                                                             BUG14620A
      ** Call program SD000056                                                             BUG14620A
     C                   IF         WyearHoll >= WyearBank                                 BUG14620A
     C**********         IF         WyearHoll = WyearBank and PMODEINIT <> '1'   BUG14620A BUG14620D
     C**********         GOTO      NEXT                                          BUG14620A BUG14620D
     C**********         ELSE                                                    BUG14620A BUG14620D
      ** Call program SD000056
     C                   CALL(E)   'SD000056'
      ** Input Parameter
     C                   PARM                    PARM1
 
      ** If Call Ends in an ERROR, execute SR *PSSR
 
     C                   IF        %ERROR
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE   =  '*CALL'
     C                   EVAL      DBKEY   =   'SD000056'
     C                   EVAL      DBASE   =   011
     C                   EVAL      DBPROC =  'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C**********         ENDIF                                                   BUG14620A BUG14620D
     C                   ENDIF                                                             BUG14620A
     C*****NEXT*         TAG                                                     BUG14620A BUG14620D
 
      ** Read the next record
     C                   READ      SDHOLPD
 
     C                   ENDDO
      *
      ** End Program and Return to Caller
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GETRCDLN - Subroutine to get record lengths of Transaction   *
      *             Data Blocks.                                      *
      *                                                               *
      *  Called by: Called in the Main Processing                     *
      *                                                               *
      *  Calls: UTGETRCDLN                                            *
      *                                                               *
      *****************************************************************
     C     GETRCDLN      BEGSR
 
     C                   CALLB     'UTGETRCDLN'
 
      ** Return code
     C                   PARM                    ReturnCode
      ** Record length
     C                   PARM      *ZEROS        RecordLen
 
      ** File name
     C                   PARM                    FileName
      ** File library
     C                   PARM      '*LIBL     '  FileLib
 
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
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   OUT       LDA
      *
     C                   DUMP
      *
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
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  PMODEINIT                                 BUG14620A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2007

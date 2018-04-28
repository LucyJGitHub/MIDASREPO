     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Update of KYC Messages from Compliance Wa')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDKYCMUPD - Midas SD Update of KYC Messages from Compliance  *
      *              Watch                                            *
      *                                                               *
      *  Function:  This is an RPG program that will update the KYC   *
      *             status and details of the customer.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 05May06               *
      *  Prev Amend No. BUG10603           Date 02Mar06               *
      *                 BUG10603           Date 14Feb06               *
      *                 CSD028  *CREATE    Date 22Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  BUG10603 - (Reopen) Compliance Alert Changes for KYC         *
/*    *  BUG10603 - Change Control for KYC                            *
      *  CSD028 - Standing Data Authorizations                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDKYCIL0  UF A E           K DISK    INFSR(*PSSR)
      ** KYC Investigation Items
 
     FSDAULGL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Log
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Log Message Array                                                                  BUG10603
     D LOGMSG          S             60A   DIM(4) CTDATA                                    BUG10603
                                                                                            BUG10603
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D PRetCde         S             10
     D PCustNum        S              6
     D PKYCSts         S              1
     D*PKYCAll**       S            500                                                     BUG10603
     D PKYCAll         S           5000                                                     BUG10603
     D WAULKey         S             26
     D*WCustNum**      S              6  0                                                   CSD027A
     D WCustNum        S              6A                                                     CSD027A
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
                                                                                            BUG10603
      ** KYC Logger Parameters                                                              BUG10603
     D PPgmName        S             10A                                                    BUG10603
     D PLogType        S             10A                                                    BUG10603
     D PLogMsg         S             60A                                                    BUG10603
                                                                                            BUG10603
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
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   MOVE      PCustNum      WCustNum
 
     C     WCustNum      CHAIN     SDKYCIL0
 
      ** Move data to KYC fields
 
     C                   EVAL      KYCNUM = WCustNum
     C                   EVAL      KYSTAT = PKYCSts
 
     C                   IF        PKYCSts = 'S'
     C                   EVAL      KYSTAT = 'I'
     C                   EVAL      KYALLI = PKYCAll
     C                   EVAL      KYOUTI = PKYCAll
     C                   ENDIF
     C                   IF        PKYCSts = 'U'
     C                   EVAL      KYOUTI = PKYCAll
     C                   ENDIF
 
      ** Update KYC File if found
 
     C                   IF        %FOUND(SDKYCIL0)
 
     C                   UPDATE    SDKYCID0
 
     C                   EVAL      PLogMsg = LOGMSG(1)                                      BUG10603
     C                   EXSR      SRWrtLog                                                 BUG10603
                                                                                            BUG10603
     C                   IF        PKYCSts = 'S' OR PKYCSts = 'R'
     C                             OR PKYCSts = 'A'
 
     C                   IF        PKYCSts = 'S'
     C                   EVAL      PKYCSts = 'I'
     C                   ENDIF
 
      ** Update Status on Authorization Log File
 
     C                   EVAL      WAULKey = PCustNum
 
     C     WAULKey       CHAIN     SDAULGL0
     C                   IF        %FOUND(SDAULGL0)
     C                   EVAL      ALSTAT = PKYCSts
     C                   UPDATE    SDAULGD0
                                                                                            BUG10603
     C                   EVAL      PLogMsg = LOGMSG(3)                                      BUG10603
     C                   EXSR      SRWrtLog                                                 BUG10603
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   ELSE
 
      ** Write record to KYC file
 
     C                   EVAL      KYORED = BJRDNB
 
     C                   WRITE     SDKYCID0
 
     C                   EVAL      PLogMsg = LOGMSG(2)                                      BUG10603
     C                   EXSR      SRWrtLog                                                 BUG10603
                                                                                            BUG10603
      ** Update Status on Authorization Log File
 
     C                   IF        PKYCSts = 'S'
 
     C                   EVAL      PKYCSts = 'I'
     C                   EVAL      WAULKey = PCustNum
 
     C     WAULKey       CHAIN     SDAULGL0
     C                   IF        %FOUND(SDAULGL0)
     C                   EVAL      ALSTAT = PKYCSts
     C                   UPDATE    SDAULGD0
                                                                                            BUG10603
     C                   EVAL      PLogMsg = LOGMSG(3)                                      BUG10603
     C                   EXSR      SRWrtLog                                                 BUG10603
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************                     BUG10603
      /EJECT                                                                                BUG10603
      *****************************************************************                     BUG10603
      *                                                               *                     BUG10603
      *  SRWrtLog - Writes to the KYC Log.                            *                     BUG10603
      *                                                               *                     BUG10603
      *****************************************************************                     BUG10603
     C     SRWrtLog      BEGSR                                                              BUG10603
                                                                                            BUG10603
     C                   CALL      'SD000054'                                               BUG10603
     C                   PARM      'SDKYCMUPD'   PPgmName                                   BUG10603
     C                   PARM                    PLogType                                   BUG10603
     C                   PARM                    PLogMsg                                    BUG10603
                                                                                            BUG10603
     C                   ENDSR                                                              BUG10603
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
     C                   PARM                    PRetCde
     C                   PARM                    PCustNum
     C                   PARM                    PKYCSts
     C                   PARM                    PKYCAll
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'SDKYCMUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      PLogMsg = LOGMSG(4)                                      BUG10603
     C                   EXSR      SRWrtLog                                                 BUG10603
                                                                                            BUG10603
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
** LOGMSG                                                                                   BUG10603
Customer found in SDKYCIPD. Record updated.                                                 BUG10603
Customer not found in SDKYCIPD. New record written.                                         BUG10603
Customer found in SDAULGPD. Record updated.                                                 BUG10603
SDKYCMUPD terminated abnormally.                                                            BUG10603

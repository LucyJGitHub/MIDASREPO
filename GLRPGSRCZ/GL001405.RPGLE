     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL MT94x Production Control')                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001405 - MT94x Production Control                          *
      *                                                               *
      *  Function:  This module sets up GLM94XPD records that are     *
      *             eligible for MT941/MT942 message generation.      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD055218           Date 11Mar20               *
      *  Prev Amend No. MD054662           Date 30Oct19               *
      *                 MD051746           Date 03May19               *
      *                 AR589183           Date 03May19               *
      *                 AR740400           Date 03May19               *
      *                 MD051723           Date 17Sep18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD024640           Date 29Jan14               *
      *                 MD024452           Date 21Jan14               *
      *                 CGL146A            Date 10Jul13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 217556             Date 30May03               *
      *                 CGL013  *CREATE    Date 09May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055218 - Dump generated in GLC001400 job                   *
      *  MD054662 - Emergency fix for case 02186832                   *
      *             Messages requested for current date are not       *
      *             processed (job GLC001415 is not submitted)        *
      *  MD051746 - Added COB Start Date in validating MT941/MT942    *
      *             requests                                          *
      *  AR589183 - Wrong status of scheduled MT941/MT942. Process    *
      *             records in GLMR94L5 with request date less than   *
      *             or equal to run date.                             *
      *           - Applied for MD-51746                              *
      *  AR740400 - MT94x Message Generation schedules expire due to  *
      *             incorrect COB Start Time retrieved. Use CBStart   *
      *             *DTAARA and retrieve CSTI as COB Start Time.      *
      *             (Child: AR740401)                                 *
      *           - Applied for MD-51746                              *
      *  MD051723 - After submitting a batch header and requesting    *
      *             the MT940 in Message Management menu, the MT940   *
      *             of the batch was not generated in MGOMSGPD.       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD024640 - Control the submission of MT940/MT950 in I/C      *
      *             via CGL146.                                       *
      *            Amended Hook: CGL146_111                           *
      *            Added Hooks:  CGL146_139, CGL146_140               *
      *  MD024452 - Avoid array index error, apply fix 228650.        *
      *  CGL146A - MT940/MT950 Production in Input Cycle              *
      *            Added hooks: CGL146_111                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  217556 - MT942 not generated according schedule              *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      * Use of indicators.                                            *
      *                                                               *
      * 71 - Network Active                                           *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
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

     FGLMR94L5  UF   E           K DISK    INFSR(*PSSR)
      ** Midas GL MT941/942 Message Requests Update Index

     FGLNWKAL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Network Activity Control File.

     FGLPRMOPD  IF   E             DISK    INFSR(*PSSR)
      ** Midas GL Production Monitor File.

     F***CBTRACPD  IF   E             DISK    INFSR(*PSSR)                           217556 AR740400
      ***Midas*CB*COB*trace.*******************************************              217556 AR740400

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of Automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D NetAct          S              6A   DIM(200)
      ** Array containing the Network active.

     D GLM94XDA      E DS                  EXTNAME(GLM94XDA) DTAARA(GLM94XDA)
      ** Midas GL MT94x Background Job Data Area

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External Data Structure for Bank Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs: Short Data Structure

     D CBStartTime   E DS                  EXTNAME(CBStart)                                 AR740400
     D  CobStartDate          33     37                                                     MD051746
     D  CobStartTime          38     43                                                     AR740400
      ** Data Area containing COB Start Time                                                AR740400

     C/COPY OFCPYSRCZ,CGL146_139                                                            MD024640
                                                                                            MD024640
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Entry Parameters
     D PRetCode        S              7                                         Return code
     D PWaitTime       S              5  0                                      Wait Time
     D PSubmit         S              1                                         Submit Y/N
     D WUpdate         S              1                                                     MD055218

     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option

     D WkExpTime       S              4A                                        Expiring time
     D WkCurTimAlp     S              4A                                        Current  time
     D WkStartDate     S              5S 0                                                 MD051746
     D WkStartTime     S              4A                                        Start time


     D WkCurTime       S               T                                        Current  time
     D WkTime          S               T                                        Working Time
     D WkNum6          S              6S 0                                      Working Time
     D WkNum8          S              8S 0                                      Working Time
     D Idx             S              5U 0 INZ(0)                               Index

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PRetCode                       Return code
     C                   PARM                    PWaitTime                      Wait Time
     C                   PARM                    PSubmit                        Submit Y/N

      ** Set defaults.

     C                   EVAL      PRetCode  = *BLANKS
     C                   EVAL      PWaitTime = 99999
     C                   EVAL      PSubmit   = 'N'

      ** Read PF/GLPRMOPD to get Period of Expiring Request value and
      **                         Minimum Running Periodicity.

     C     1             CHAIN     GLPRMOPD

      ** Retrieve the Expiring Time.

     C                   IF        NOT %EOF(GLPRMOPD)
     C                   TIME                    WkTime
     C                   SUBDUR    MDPERQ:*MN    WkTime
     C                   MOVEL     WkTime        WkNum8
     C                   MOVEL     Wknum8        WkExpTime
     C                   ELSE
     C                   MOVEL     *LOVAL        WkExpTime
     C                   ENDIF

      ** Retrieve the Current Time.

     C                   TIME                    WkCurTime
     C                   MOVEL     WkCurTime     WkNum8
     C                   MOVEL     Wknum8        WkCurTimAlp
     C
      *                                                                                       228650
      ** Initialize array before each read loop                                               228650
     C                   EVAL      Idx = 0                                                    228650
     C                   EVAL      Netact = *blanks                                           228650
      *                                                                                       228650
      ** Read LF/GLNWKAL0 to get Active Network.

     C     *LOVAL        SETLL     GLNWKAL0
     C                   READ      GLNWKAL0
     C                   DOW       NOT %EOF(GLNWKAL0)
     C                   IF        MTSSTS = 'A'                                 Network Active
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      NetAct(Idx) = MTNWRK
     C                   ENDIF
     C                   READ      GLNWKAL0
     C                   ENDDO

      ** Retrieve the status of MT941/MT942 request.

     C                   IN        GLM94XDA
      *                                                                                     AR740400
      ** Retrieve the Cob Start Time from CBSTAT Data Area.                                 AR740400
      *                                                                                     AR740400
     C     *DTAARA       DEFINE    CBStart       CBStartTime                                AR740400
     C                   IN        CBStartTime                                              AR740400
      *                                                                                       217556
      ** Read PF/CBTRACPD to get the start time of the previous COB .                         217556
      *                                                                                       217556
     C                   MOVEL     '0000'        WkStartTime                                  217556
      *                                                                                       217556
     C****1****         CHAIN     CBTRACPD                                           217556 AR740400
      *                                                                                       217556
     C**********         IF        NOT %EOF(CBTRACPD)                                217556 AR740400
     C**********         MOVEL     TRTIME        WkStartTime                         217556 AR740400
     C                   MOVEL     CobStartTime  WkStartTime                                AR740400
     C                   MOVEL     CobStartDate  WkStartDate                                MD051746
     C                   IF        WkStartTime > WkCurTimAlp                                  217556
     C                   MOVEL     '0000'        WkStartTime                                  217556
     C                   ENDIF                                                                217556
     C**********         ENDIF                                                       217556 AR740400

      ** Read the today's waiting requests with a request time less than or equal
      ** to current time.

     C*****BJRDNB        SETLL     GLMR94L5                                                 AR589183
     C*****BJRDNB        READE     GLMR94L5                                                 AR589183
     C     *LOVAL        SETLL     GLMR94L5                                                 AR589183
     C                   READ      GLMR94L5                                                 AR589183

     C                   DOW       NOT %EOF(GLMR94L5)
     C**********                   AND MRSRTIM <= WkCurTimAlp           Request time issued AR589183

      *
      ** Requests expired.
      *
     C                   EVAL      Wupdate = 'N'                                            MD055218
     C     MRRDTE        IFLT      WkStartDate                                              MD051746
     C                   EVAL      MRSTAT = 'EXPIRED'                                       MD051746
     C                   UPDATE    GLMR94D0                                                 MD051746
     C                   EVAL      Wupdate = 'Y'                                            MD055218
     C                   ENDIF                                                              MD051746
      *****

     C     MRRDTE        IFLE      BJRDNB                                                   AR589183
     C     MRSRTIM       ANDLE     WkCurTimAlp                                              AR589183

      ** If the current processing time is between start of COB and mid-night, process only  217556
      ** requests with expected time greater than the start of COB.                          217556
      *                                                                                      217556
     C                   IF            MRSRTIM <   WkStartTime                               217556
     C                             AND MRSRTIM <> 'IMED'                        Request time 217556
     C                             AND MRRDTE >=  BJRDNB                                    MD051746
     C     KeySelReq     SETLL     GLMR94L5                                                  217556
     C                   ELSE                                                                217556
      *                                                                                      217556

      **   Check if the network is active.

     C     MRNWRK        LOOKUP    NetAct                                 71

     C                   IF        *IN71                                        Network Active

      ** Requests expired.

     C
     C*****MRRDTE        IFLE      WkStartDate                                     MD051746 MD054662
     C                   IF        MRSRTIM <= WkExpTime                         Request Expired
     C                             AND MRSRTIM <> 'IMED'                        Not Immediate Req.
     C                             AND MRRDTE <= WkStartDate                                MD054662
     C                   EVAL      MRSTAT = 'EXPIRED'
     C                   ELSE

      ** Requests to submit.

      **   According :
      **         - the message type of the request (MRMTPY),
      **         - the source of posting (MRSORQ i.d. MANUAL, SCHEDULE, or MT920),
      **         - the generation flag indicator (MTS941, MTS942, MTM941,
      **                                          MTM942, MTR941, MTR942),
      **   Set the status to SUBMITTED.

     C                   SELECT
     C                   WHEN      MRMTPY = '941'                               Message type request
     C                             AND MRSORQ = 'MANUAL'                        Source of Request
     C                             AND MTM941 = 'Y'                             MT941 Manual Request
     C                   EVAL      MRSTAT = 'SUBMITTED'                         Change Status
     C                   EVAL      PSubmit   = 'Y'                              Submit Generation

     C                   WHEN      MRMTPY = '942'                               Message type request
     C                             AND MRSORQ = 'MANUAL'                        Source of Request
     C                             AND MTM942 = 'Y'                             MT942 Manual Request
     C                   EVAL      MRSTAT = 'SUBMITTED'                         Change Status
     C                   EVAL      PSubmit   = 'Y'                              Submit Generation

     C                   WHEN      MRMTPY = '941'                               Message type request
     C                             AND MRSORQ = 'SCHEDULE'                      Source of Request
     C                             AND MTS941 = 'Y'                             MT941 Request Sched.
     C                   EVAL      MRSTAT = 'SUBMITTED'                         Change Status
     C                   EVAL      PSubmit   = 'Y'                              Submit Generation

     C                   WHEN      MRMTPY = '942'                               Message type request
     C                             AND MRSORQ = 'SCHEDULE'                      Source of Request
     C                             AND MTS942 = 'Y'                             MT942 Request Sched.
     C                   EVAL      MRSTAT = 'SUBMITTED'                         Change Status
     C                   EVAL      PSubmit   = 'Y'                              Submit Generation

     C                   WHEN      MRMTPY = '941'                               Message type request
     C                             AND MRSORQ = 'MT920'                         Source of Request
     C                             AND MTR941 = 'Y'                             MT941 on MT920 Req.
     C                   EVAL      MRSTAT = 'SUBMITTED'                         Change Status
     C                   EVAL      PSubmit   = 'Y'                              Submit Generation

     C                   WHEN      MRMTPY = '942'                               Message type request
     C                             AND MRSORQ = 'MT920'                         Source of Request
     C                             AND MTR942 = 'Y'                             MT942 on MT920 Req.
     C                   EVAL      MRSTAT = 'SUBMITTED'                         Change Status
     C                   EVAL      PSubmit   = 'Y'                              Submit Generation
     C/COPY OFCPYSRCZ,CGL146_111                                                             CGL146A
     C                   ENDSL

     C                   ENDIF
     C**********         ENDIF                                                     MD051746 MD054662

     C                   ENDIF

     C                   IF        Wupdate = 'N'                                            MD055218
     C                   UPDATE    GLMR94D0
     C                   ENDIF                                                              MD055218

     C                   ENDIF                                                               217556
     C                   ENDIF                                                              AR589183

     C*****BJRDNB        READE     GLMR94L5                                                 AR589183
     C                   READ      GLMR94L5                                                 AR589183

     C                   ENDDO

      ** Calculate the wait time.

      ** Now the wait time correspond to the difference in seconds between the
      ** next request time and the current one.

      ** If end of file, position the file at the beginnig to retrieve the next request       217556
      *                                                                                       217556
     C                   IF        %EOF(GLMR94L5)                                             217556
     C*****BJRDNB        SETLL     GLMR94L5                                          217556 AR589183
     C*****BJRDNB        READE     GLMR94L5                                          217556 AR589183
     C     *LOVAL        SETLL     GLMR94L5                                                 AR589183
     C                   READ      GLMR94L5                                                 AR589183
     C                   ENDIF                                                                217556

     C                   IF        NOT %EOF(GLMR94L5)
     C                             AND MRSRTIM <> 'IMED'                                    MD051723
     C                   EVAL      WkNum6 = *ZEROS
     C                   MOVEL     MRSRTIM       WkNum6                         Request Time
     C     *HMS          MOVE      WkNum6        WkTime
     C     WkTime        SUBDUR    WkCurTime     PWaitTime:*s

     C                   SELECT

      ***If*the*wait*time*is*less*than*zeros,*there is a problem -> Restart the process.      217556
      ** If the wait time is less than zeros, the current time is before mid-night and        217556
      ** the next request is after mid-night.                                                 217556

     C                   WHEN      PWaitTime < *ZEROS
     C*******            EVAL      PWaitTime = *ZEROS                                         217556
     C*******            EVAL      PRetCode  = '*RSTART'                                      217556
     C     *HMS0         MOVE      '240000'      WkTime                                       217556
     C     WkTime        SUBDUR    WkCurTime     PWaitTime:*s                                 217556

      ** If the wait time is less than Minimum Running Periodicity, set the wait time
      ** to the Minimum Running Periodicity.

     C                   WHEN      PWaitTime < (MDMRPD * 60)
     C                   EVAL      PWaitTime = MDMRPD * 60
     C                   ENDSL

     C                   ENDIF

     C                   UNLOCK    GLMR94L5
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Retrieve Bank details.

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDBANK        PARM      SDBANK        DSFDY

     C/COPY OFCPYSRCZ,CGL146_140                                                            MD024640
                                                                                            MD024640
     C     KeySelReq     KLIST                                                               217556
     C                   KFLD                    BJRDNB                                      217556
     C                   KFLD                    WkStartTime                                 217556

     C                   ENDSR


      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program Exception Error Routine                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   EVAL      PRetCode  = '*ERROR'

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
